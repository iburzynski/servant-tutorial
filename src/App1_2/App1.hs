{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module App1_2.App1 where

import App1_2.Data
import Servant

type UserAPI1 = "users" :> Get '[JSON] [User]

-- Server UserAPI1 --> ServerT UserAPI1 Handler --> ...
-- type ServerT ("users" :> Get '[JSON] [User]) Handler = ServerT (Get '[JSON] [User]) Handler
-- type ServerT (Get '[JSON] [User]) Handler = Handler [User]

handler1 :: Server UserAPI1
handler1 = pure users1

userAPIproxy :: Proxy UserAPI1
userAPIproxy = Proxy

app1 :: Application
app1 = serve userAPIproxy handler1