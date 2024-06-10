{-# LANGUAGE OverloadedStrings #-}

import Codec.Binary.UTF8.String qualified as UTF8
import DBus qualified as D
import DBus.Client qualified as D
import Data.Map qualified as M
import Data.Monoid
import Graphics.X11.ExtraTypes.XF86
import XMonad
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

myModMask :: KeyMask
myModMask = mod4Mask

-- Colors
colorFocusedBorder :: String
colorFocusedBorder = "@color5@"

colorNormalBorder :: String
colorNormalBorder = "@color0@"

-- Define default config
baseConfig = ewmh desktopConfig

main :: IO ()
main = do
  spawn myBar
  dbus <- mkDbusClient
  xmonad $ ewmhFullscreen . docks $ mkConfig dbus

mkDbusClient :: IO D.Client
mkDbusClient = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.log") opts
  return dbus
  where
    opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

-- Status bar display
myLogHook :: D.Client -> PP
myLogHook dbus =
  def
    { ppOutput = dbusOutput dbus,
      ppCurrent = wrap "%{F@color0@}%{B@color3@}  " "  %{B-}%{F-}",
      ppVisible = wrap "%{F@color0@}%{B@color15@}  " "  %{B-}%{F-}",
      ppUrgent = wrap "%{B@color1@}%{F@color0@}  " "  %{F-}%{B-}",
      ppHidden = wrap " " " ",
      ppWsSep = "",
      ppSep = " : ",
      ppTitle = wrap "%{F@color2@} " " %{F-}" . shorten 120
    }

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str =
  let opath = D.objectPath_ "/org/xmonad/Log"
      iname = D.interfaceName_ "org.xmonad.Log"
      mname = D.memberName_ "Update"
      signal = D.signal opath iname mname
      body = [D.toVariant $ UTF8.decodeString str]
   in D.emit dbus $ signal {D.signalBody = body}

mkConfig dbus =
  removeMyKeys . addMyKeys $
    baseConfig
      { modMask = myModMask,
        terminal = myTerminal,
        startupHook = setWMName "LG3D",
        focusFollowsMouse = False,
        workspaces = myWorkspaces,
        manageHook = myManageHook,
        layoutHook = myLayoutHook,
        focusedBorderColor = colorFocusedBorder,
        normalBorderColor = colorNormalBorder,
        borderWidth = myBorderWidth,
        logHook = dynamicLogWithPP (myLogHook dbus)
      }

-- Handling some rules for specific apps
myManageHook :: ManageHook
myManageHook =
  manageDocks
    <+> manageHookConfig
    <+> composeOne
      [ isFullscreen -?> doF W.focusDown <+> doFullFloat,
        isDialog -?> doFloat
      ]
  where
    manageHookConfig = manageHook baseConfig

myLayoutHook = avoidStruts $ smartBorders $ layoutHook baseConfig

-- Add Extra keys to default
addMyKeys :: XConfig a -> XConfig a
addMyKeys conf@XConfig {XMonad.modMask = extraKeysModMask} =
  additionalKeys
    conf
    []

-- Remove keys from default
removeMyKeys :: XConfig a -> XConfig a
removeMyKeys conf@XConfig {XMonad.modMask = extraKeysModMask} =
  removeKeys
    conf
    [ (extraKeysModMask, xK_p),
      (extraKeysModMask .|. shiftMask, xK_p),
      (extraKeysModMask .|. shiftMask, xK_slash)
    ]

myBar :: String
myBar = unwords ["@runbar@"]

myTerminal :: String
myTerminal = unwords ["@terminal@"]

myRestartXmonad :: String
myRestartXmonad =
  unwords
    [ "xmonad --recompile;",
      "xmonad --restart;",
      "@notifysend@ 'Xmonad reloaded';"
    ]

myBorderWidth :: Dimension
myBorderWidth = 1

myWorkspaces :: [String]
myWorkspaces = map show ([1 .. 9] :: [Int])
