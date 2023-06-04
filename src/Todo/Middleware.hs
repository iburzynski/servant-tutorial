module Todo.Middleware where

import Network.HTTP.Types (status200)
import Network.Wai
  ( Middleware,
    Request (requestMethod),
    responseLBS, Application,
  )
import Network.Wai.Middleware.AddHeaders (addHeaders)

allowCors :: Middleware
allowCors =
  addHeaders
    [ ("Access-Control-Allow-Origin", "*"),
      ("Access-Control-Allow-Headers", "Accept, Content-Type"),
      ("Access-Control-Allow-Methods", "GET, HEAD, POST, DELETE, OPTIONS, PUT, PATCH")
    ]

allowOptions :: Middleware
allowOptions app req resp = case requestMethod req of
  "OPTIONS" -> resp $ responseLBS status200 [] "Ok"
  _ -> app req resp

applyMiddleware :: Application -> Application
applyMiddleware = allowCors . allowOptions