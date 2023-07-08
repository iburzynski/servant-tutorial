module App3.Client where

import App3.App (API)
import App3.Data
  ( ClientInfo (ClientInfo),
    Email,
    FileContent,
    HelloMessage,
    Position,
  )
import Network.HTTP.Client (defaultManagerSettings, newManager)
import Servant
import Servant.Client (BaseUrl (BaseUrl), ClientM, Scheme (Http), client, mkClientEnv, runClientM)

position :: Int -> Int -> ClientM Position
hello :: Maybe [Char] -> ClientM HelloMessage
marketing :: ClientInfo -> ClientM Email
file :: ClientM FileContent
position :<|> hello :<|> marketing :<|> file = client @API Proxy

queries :: ClientM (Position, HelloMessage, Email, FileContent)
queries = do
  pos <- position 10 10
  message <- hello (Just "servant")
  email <- marketing (ClientInfo "Alp" "alp@foo.com" 26 ["haskell", "mathematics"])
  myFile <- file
  pure (pos, message, email, myFile)

run :: IO ()
run = do
  mgr <- newManager defaultManagerSettings
  res <- runClientM queries (mkClientEnv mgr (BaseUrl Http "localhost" 8081 ""))
  case res of
    Left err -> putStrLn $ "Error: " ++ show err
    Right (pos, message, email, myFile) -> do
      print pos
      print message
      print email
      print myFile