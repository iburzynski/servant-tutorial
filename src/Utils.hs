module Utils where
import System.Environment (getEnv)
import Network.Wai.Handler.Warp (Port)

type URLRoot = String

getPort :: IO Port
getPort = read <$> getEnv "PORT"

getURLRoot :: IO URLRoot
getURLRoot = getEnv "URL_ROOT"