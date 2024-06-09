{-# LANGUAGE OverloadedStrings #-}
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Minimize
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders
import Graphics.X11.ExtraTypes.XF86
import Data.Monoid
import XMonad.Layout.LayoutModifier
import XMonad.Hooks.SetWMName
import qualified Codec.Binary.UTF8.String as UTF8

import XMonad.Hooks.DynamicLog
import qualified DBus as D
import qualified DBus.Client as D

import qualified XMonad.StackSet as W
import qualified Data.Map as M

-- colors
colorFocusedBorder :: String
colorFocusedBorder = "@color5@"

colorNormalBorder :: String
colorNormalBorder = "@color0@"

-- define default config
baseConfig = ewmh desktopConfig

-- main
main :: IO ()
main = do
    spawn myBar

    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

    xmonad $ ewmhFullscreen . docks $ myConfig { logHook = dynamicLogWithPP (myLogHook dbus) }

-- Override the PP values as you would otherwise, adding colors etc depending
-- on  the statusbar used
myLogHook :: D.Client -> PP
myLogHook dbus = def
    { ppOutput = dbusOutput dbus
    , ppCurrent = wrap "%{F@color0@}%{B@color3@}  " "  %{B-}%{F-}"
    , ppVisible = wrap "%{F@color0@}%{B@color15@}  " "  %{B-}%{F-}"
    , ppUrgent = wrap "%{B@color1@}%{F@color0@}  " "  %{F-}%{B-}"
    , ppHidden = wrap " " " "
    , ppWsSep = ""
    , ppSep = " : "
    , ppTitle = wrap "%{F@color2@} " " %{F-}" . shorten 120
    }

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

myModMask :: KeyMask
myModMask = mod4Mask

-- my config
myConfig = baseConfig
    { modMask = myModMask
    , terminal = myTerminal
    , startupHook = setWMName "LG3D"
    , focusFollowsMouse = False
    , workspaces = myWorkspaces
    , manageHook = myManageHook
    , layoutHook = myLayoutHook
    , focusedBorderColor = colorFocusedBorder
    , normalBorderColor = colorNormalBorder
    , borderWidth = myBorderWidth
    , keys = \c -> myKeys c `M.union` keys baseConfig c
    }

-- manage apps
myManageHook :: ManageHook
myManageHook = manageDocks <+> manageHookConfig <+> composeOne
    [ isFullscreen                -?> doF W.focusDown <+> doFullFloat
    ]
    where manageHookConfig = manageHook baseConfig

-- layouts
myLayoutHook = avoidStruts $ smartBorders $ layoutHook baseConfig

-- my keys
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys XConfig {XMonad.modMask = extraKeysModMask} = M.empty

-- my bar
myBar :: String
myBar = unwords [ "@runbar@" ]

-- terminal
myTerminal :: String
myTerminal = unwords [ "@terminal@" ]

-- restart xmonad
myRestartXmonad :: String
myRestartXmonad = unwords
    [ "xmonad --recompile;"
    , "xmonad --restart;"
    , "notify-send 'Xmonad reloaded';"
    ]

-- border width
myBorderWidth :: Dimension
myBorderWidth = 1

-- workspaces
myWorkspaces :: [String]
myWorkspaces = map show ([1..9] :: [Int])
