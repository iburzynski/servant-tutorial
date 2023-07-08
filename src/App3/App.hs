module App3.App where

import App3.Data
import Control.Monad.IO.Class (MonadIO (liftIO))
import Servant
import System.Directory (doesFileExist)

type API =
  "position" :> Capture "x" Int :> Capture "y" Int :> Get '[JSON] Position
    :<|> "hello" :> QueryParam "name" String :> Get '[JSON] HelloMessage
    :<|> "marketing" :> ReqBody '[JSON] ClientInfo :> Post '[JSON] Email
    :<|> "myfile.txt" :> Get '[JSON] FileContent

position :: Int -> Int -> Handler Position
position x y = pure (Position x y)

hello :: Maybe String -> Handler HelloMessage
hello mname = pure . HelloMessage $ case mname of
  Nothing -> "Hello, anonymous coward"
  Just n -> "Hello, " ++ n

marketing :: ClientInfo -> Handler Email
marketing clientinfo = pure (emailForClient clientinfo)

file :: Handler FileContent
file = do
  exists <- liftIO (doesFileExist "myfile.txt")
  if exists
    then do
      filecontent <- liftIO (readFile "myfile.txt")
      pure (FileContent filecontent)
    else throwError (err404 {errBody = "myfile.txt doesn't exist"})

app3 :: Application
app3 = serve @API Proxy (position :<|> hello :<|> marketing :<|> file)