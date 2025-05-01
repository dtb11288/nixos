{-# LANGUAGE OverloadedStrings #-}

import Codec.Binary.UTF8.String qualified as UTF8
import DBus.Client qualified as DC
import Data.Map qualified as M
import Data.Monoid
import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.Config.Desktop
import XMonad.DBus qualified as D
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Minimize
import XMonad.Hooks.SetWMName
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Renamed
import XMonad.Layout.Tabbed
import XMonad.StackSet qualified as W
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.Themes
import XMonad.Util.WorkspaceCompare


-- @color0@ @color1@ @color2@ @color3@ @color4@ @color5@ @color6@ @color7@
-- @color8@ @color9@ @color10@ @color11@ @color12@ @color13@ @color14@ @color15@
-- @foreground@ @background@

myModMask :: KeyMask
myModMask = mod4Mask

myColorFocusedBorder :: String
myColorFocusedBorder = "@color5@"

myColorNormalBorder :: String
myColorNormalBorder = "@color0@"

myBorderWidth :: Dimension
myBorderWidth = 1

myWorkspaces :: [String]
myWorkspaces = map show ([1 .. 9] :: [Int])

myBar :: String
myBar = unwords ["@runbar@"]

myBarLog :: PP
myBarLog =
  def
    { ppCurrent = wrap "%{F@color0@}%{B@color3@}  " "  %{B-}%{F-}"
    , ppVisible = wrap "%{F@color0@}%{B@color15@}  " "  %{B-}%{F-}"
    , ppUrgent = wrap "%{B@color1@}%{F@color0@}  " "  %{F-}%{B-}"
    , ppHidden = wrap " " " "
    , ppWsSep = ""
    , ppSep = " : "
    , ppTitle = wrap "%{F@color2@} " " %{F-}" . shorten 120
    }

myWindowConditions =
  [isFullscreen --> doF W.focusDown <+> doFullFloat]
    -- Window types
    <> [ "SPLASH" ==> doCenterFloat
       , "DIALOG" ==> doFloat
       , "UTILITY" ==> doFloat
       , "MENU" ==> doFloat
       , "NOTIFICATION" ==> doFloat
       ]
    -- Special apps
    <> [ "steam" =?> doFloat
       , "battle.net.exe" =?> doFloat
       , "mpv" =?> doFloat
       , "file-roller" =?> doFloat
       ]
 where
  name ==> action = checkProperty name --> action
  name =?> action = className =? name --> action
  checkProperty pType =
    let root = "_NET_WM_WINDOW_TYPE"
     in isInProperty root $ root <> "_" <> pType

myLayout = onWorkspace "2" myWSLayout myDefaultLayout
 where
  layout ==> newName = renamed [Replace newName] layout
  myWSLayout = myTab
  myDefaultLayout = myTall ||| myMTall ||| myTab ||| Full
  myTall = Tall 1 (3 / 100) (1 / 2)
  myMTall = Mirror (Tall 1 (3 / 100) (1 / 2)) ==> "MTall"
  myTab = tabbed shrinkText myTabConfig ==> "Tab"
  myFull = Full
  myTabConfig =
    def
      { activeColor = "@color0@"
      , inactiveColor = "@color8@"
      , urgentColor = "@color1@"
      , activeBorderColor = "@color0@"
      , inactiveBorderColor = "@color8@"
      , urgentBorderColor = "@color1@"
      , activeTextColor = "@color10@"
      , inactiveTextColor = "@color7@"
      , urgentTextColor = "@color0@"
      , fontName = "xft:Noto Sans:bold:size=11"
      , decoHeight = read "@tabheight@"
      }

myScatchPads :: [NamedScratchpad]
myScatchPads =
  [ NS "easyeffects" "@easyeffects@" (title =? "Easy Effects") $ mkCenter 0.7 0.7
  , NS "htop" "@htop@" (title =? "htop") $ mkCenter 0.7 0.7
  , NS "pomodoro" "@pomodoro@" (title =? "Pomodoro") $ mkCenter 0.3 0.3
  ]
 where
  mkCenter :: Rational -> Rational -> ManageHook
  mkCenter w h = customFloating $ W.RationalRect l r w h
   where
    l = (1.0 - w) / 2.0
    r = (1.0 - h) / 2.0

additionKeys :: [((KeyMask, KeySym), X ())]
additionKeys =
  [ ((myModMask .|. shiftMask, xK_e), callScratchPad "easyeffects")
  , ((myModMask .|. shiftMask, xK_h), callScratchPad "htop")
  , ((myModMask .|. shiftMask, xK_p), callScratchPad "pomodoro")
  , ((myModMask, xK_q), spawn myRestartXmonad)
  ]
 where
  callScratchPad = namedScratchpadAction myScatchPads
  myRestartXmonad =
    unwords
      [ "@xmonad@ --recompile;"
      , "@xmonad@ --restart;"
      , "@notifysend@ 'Xmonad reloaded';"
      ]

removalKeys :: [(KeyMask, KeySym)]
removalKeys =
  [ (myModMask, xK_p)
  , (myModMask .|. shiftMask, xK_p)
  , (myModMask .|. shiftMask, xK_slash)
  , (myModMask .|. shiftMask, xK_Return)
  ]

addManageHook :: XConfig l -> XConfig l
addManageHook baseConfig =
  baseConfig{manageHook = myManageHook}
 where
  myManageHook =
    manageDocks
      <+> manageHook baseConfig
      <+> namedScratchpadManageHook myScatchPads
      <+> composeAll myWindowConditions

addLogHook :: DC.Client -> XConfig l -> XConfig l
addLogHook dbus baseConfig = baseConfig{logHook = myLogHook}
 where
  myLogHook =
    dynamicLogWithPP . filterOutWsPP [scratchpadWorkspaceTag] $
      myBarLog{ppOutput = D.send dbus}

addLayoutHook baseConfig = baseConfig{layoutHook = myLayoutHook}
 where
  myLayoutHook = avoidStruts . smartBorders $ myLayout

addStartupHook :: XConfig l -> XConfig l
addStartupHook baseConfig = baseConfig{startupHook = myStartUpHook}
 where
  myStartUpHook = setWMName "LG3D" >> startupHook baseConfig

addMyKeys :: XConfig l -> XConfig l
addMyKeys = (`additionalKeys` additionKeys)

removeMyKeys :: XConfig l -> XConfig l
removeMyKeys = (`removeKeys` removalKeys)

myBaseConfig =
  desktopConfig
    { modMask = myModMask
    , terminal = "none"
    , focusFollowsMouse = False
    , focusedBorderColor = myColorFocusedBorder
    , normalBorderColor = myColorNormalBorder
    , borderWidth = myBorderWidth
    , workspaces = myWorkspaces
    }

main :: IO ()
main = do
  spawn myBar
  dbus <- D.connect
  D.requestAccess dbus
  let myConfig =
        myBaseConfig
          |> addLayoutHook
          |> addStartupHook
          |> addLogHook dbus
          |> addManageHook
          |> removeMyKeys
          |> addMyKeys
  xmonad $ docks . ewmhFullscreen . ewmh $ myConfig
 where
  x |> f = f x
