{-# OPTIONS_GHC -Wno-unused-imports #-}

module Main where

import Network.Wai.Handler.Warp (run)
import Server1_2.Server1 (app1)
import Server1_2.Server2 (app2)
import Server3.Server3 (app3)
import Todo.DB (migrateAndRunDb)
import Todo.Server (todoApp)
import Todo.Utils (getPort, getURLRoot)

main :: IO ()
main = run 8081 app3

main' :: IO ()
main' = do
  _ <- migrateAndRunDb
  port <- getPort
  urlRoot <- getURLRoot
  run port $ todoApp urlRoot