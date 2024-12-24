{-# LANGUAGE OverloadedStrings #-}

import Codec.Binary.UTF8.String qualified as UTF8
import DBus.Client qualified as DC
import Data.Map qualified as M
import Data.Monoid
import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.DBus qualified as D
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Minimize
import XMonad.Hooks.SetWMName
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders
import XMonad.StackSet qualified as W
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.WorkspaceCompare

myModMask :: KeyMask
myModMask = mod4Mask

-- Colors
colorFocusedBorder :: String
colorFocusedBorder = "@color5@"

colorNormalBorder :: String
colorNormalBorder = "@color0@"

myBaseConfig = desktopConfig

main :: IO ()
main = do
  spawn myBar
  dbus <- D.connect
  D.requestAccess dbus
  xmonad $ docks . ewmhFullscreen . ewmh . mkConfig dbus $ myBaseConfig

-- Status bar display
mkLogHook :: DC.Client -> PP
mkLogHook dbus =
  def
    { ppOutput = D.send dbus
    , ppCurrent = wrap "%{F@color0@}%{B@color3@}  " "  %{B-}%{F-}"
    , ppVisible = wrap "%{F@color0@}%{B@color15@}  " "  %{B-}%{F-}"
    , ppUrgent = wrap "%{B@color1@}%{F@color0@}  " "  %{F-}%{B-}"
    , ppHidden = wrap " " " "
    , ppWsSep = ""
    , ppSep = " : "
    , ppTitle = wrap "%{F@color2@} " " %{F-}" . shorten 120
    }

mkConfig dbus baseConfig =
  removeMyKeys . addMyKeys $
    baseConfig
      { modMask = myModMask
      , terminal = myTerminal
      , startupHook = setWMName "LG3D"
      , focusFollowsMouse = False
      , workspaces = myWorkspaces
      , manageHook = myManageHook baseConfig
      , layoutHook = myLayoutHook baseConfig
      , focusedBorderColor = colorFocusedBorder
      , normalBorderColor = colorNormalBorder
      , borderWidth = myBorderWidth
      , logHook = myLogHook
      }
 where
  myLogHook = dynamicLogWithPP . filterOutWsPP [scratchpadWorkspaceTag] $ mkLogHook dbus

-- Handling some rules for specific apps
myManageHook :: XConfig l -> ManageHook
myManageHook baseConfig =
  manageDocks
    <+> manageHookConfig
    <+> namedScratchpadManageHook myScatchPads
    <+> composeOne
      [ isFullscreen -?> doF W.focusDown <+> doFullFloat
      , isDialog -?> doFloat
      , className =? "steam" -?> doFloat
      , className =? "mpv" -?> doFloat
      , className =? "file-roller" -?> doFloat
      , isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_SPLASH" -?> doCenterFloat
      ]
 where
  manageHookConfig = manageHook baseConfig

myLayoutHook baseConfig = avoidStruts $ smartBorders $ layoutHook baseConfig

myScatchPads :: [NamedScratchpad]
myScatchPads =
  [ NS "EasyEffects" "easyeffects" (title =? "Easy Effects") $ mkCenter 0.7 0.7
  , NS "htop" "@terminal@ -T htop -e htop" (title =? "htop") $ mkCenter 0.7 0.7
  , NS "cpupower" "@cpupower@" (title =? "cpupower-gui") $ mkCenter 0.7 0.7
  ]

mkCenter :: Rational -> Rational -> ManageHook
mkCenter w h = customFloating $ W.RationalRect l r w h
 where
  l = (1.0 - w) / 2.0
  r = (1.0 - h) / 2.0

-- Add Extra keys to default
addMyKeys :: XConfig a -> XConfig a
addMyKeys conf@XConfig{XMonad.modMask = extraKeysModMask} =
  additionalKeys
    conf
    [ ((extraKeysModMask .|. shiftMask, xK_e), callScratchPad "EasyEffects")
    , ((extraKeysModMask .|. shiftMask, xK_h), callScratchPad "htop")
    , ((extraKeysModMask .|. shiftMask, xK_g), callScratchPad "cpupower")
    ]

callScratchPad :: String -> X ()
callScratchPad = namedScratchpadAction myScatchPads

-- Remove keys from default
removeMyKeys :: XConfig a -> XConfig a
removeMyKeys conf@XConfig{XMonad.modMask = extraKeysModMask} =
  removeKeys
    conf
    [ (extraKeysModMask, xK_p)
    , (extraKeysModMask .|. shiftMask, xK_p)
    , (extraKeysModMask .|. shiftMask, xK_slash)
    ]

myBar :: String
myBar = unwords ["@runbar@"]

myTerminal :: String
myTerminal = unwords ["@terminal@"]

myRestartXmonad :: String
myRestartXmonad =
  unwords
    [ "xmonad --recompile;"
    , "xmonad --restart;"
    , "@notifysend@ 'Xmonad reloaded';"
    ]

myBorderWidth :: Dimension
myBorderWidth = 1

myWorkspaces :: [String]
myWorkspaces = map show ([1 .. 9] :: [Int])
