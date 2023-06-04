module Todo.Client where

import Data.Foldable (traverse_)
import Network.HTTP.Client (defaultManagerSettings, newManager)
import Servant (Proxy (Proxy), type (:<|>) ((:<|>)))
import Servant.Client (ClientM, client, mkClientEnv, parseBaseUrl, runClientM)
import Todo.Data (Priority (..), TodoAction (..), TodoResponse)
import Todo.Server (API)
import Todo.Utils (getURLRoot)

getTodos :: ClientM [TodoResponse]
deleteTodos :: ClientM ()
postTodo :: TodoAction -> ClientM TodoResponse
getTodo :: Integer -> ClientM TodoResponse
deleteTodo :: Integer -> ClientM ()
patchTodo :: Integer -> TodoAction -> ClientM TodoResponse
getTodos
  :<|> deleteTodos
  :<|> postTodo
  :<|> getTodo
  :<|> deleteTodo
  :<|> patchTodo = client @API Proxy

sampleTodo0 :: TodoAction
sampleTodo0 = TodoAction (Just "drink coffee") (Just False) (Just Low)

sampleTodo1 :: TodoAction
sampleTodo1 = TodoAction (Just "finish tutorial") (Just False) (Just Medium)

postSamples :: ClientM [TodoResponse]
postSamples = do
  _ <- postTodo sampleTodo0
  _ <- postTodo sampleTodo1
  getTodos

runClient :: IO ()
runClient = do
  mgr <- newManager defaultManagerSettings
  urlRoot <- getURLRoot
  baseUrl <- parseBaseUrl urlRoot
  res <- runClientM postSamples (mkClientEnv mgr baseUrl)
  case res of
    Left err -> putStrLn $ "Error: " ++ show err
    Right todos -> traverse_ print todos