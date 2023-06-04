{-# LANGUAGE TypeApplications #-}

module Server1_2.Server2 where

import Servant
import Server1_2.Data ( User, isaac, albert, users2 )

type UserAPI2 =
  "users" :> Get '[JSON] [User]
    :<|> "albert" :> Get '[JSON] User
    :<|> "isaac" :> Get '[JSON] User

app2 :: Application
app2 = serve @UserAPI2 Proxy server2 -- use type applications to specify api type and reduce boilerplate
  where
    -- Just like we separate endpoints with :<|> at the type level,
    -- we separate handlers at the value level (in the same order)
    server2 :: Server UserAPI2
    server2 =
      pure users2
        :<|> pure albert
        :<|> pure isaac