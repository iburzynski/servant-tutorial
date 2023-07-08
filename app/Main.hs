{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Main where

import App1_2.App1 (app1)
import App1_2.App2 (app2)
import App3.App (app3)
import Control.Monad (when)
import Data.Map.Strict (Map, (!))
import Network.Wai (Application)
import Network.Wai.Handler.Warp (Port, run)
import System.Environment (getArgs)
import Todo.App (todoApp)
import Todo.DB (migrateAndRunDb)
import Utils (URLRoot, getPort, getURLRoot)

data Env = Env {port :: Port, urlRoot :: URLRoot}

getApps :: Env -> Map String Application
getApps Env {..} = [("app1", app1), ("app2", app2), ("app3", app3), ("todo", todoApp urlRoot)]

runApp :: String -> IO ()
runApp name = do
  port <- getPort
  urlRoot <- getURLRoot
  let apps = getApps $ Env {..}
      app = apps ! name
  when (name == "todo") migrateAndRunDb
  putStrLn $ "Running server at " ++ urlRoot
  run port app

main :: IO ()
main = do
  args <- getArgs
  case args of
    [app] -> runApp app
    _ -> error "Invalid argument: specify the name of the app"