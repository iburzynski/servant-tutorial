{-# LANGUAGE TypeApplications #-}

module App1_2.App2 where

import Servant
import App1_2.Data ( User, isaac, albert, users2 )

type UserAPI2 =
  "users" :> Get '[JSON] [User]
    :<|> "albert" :> Get '[JSON] User
    :<|> "isaac" :> Get '[JSON] User

app2 :: Application
app2 = serve @UserAPI2 Proxy handlers -- use type applications to specify api type and reduce boilerplate
  where
    -- Just like we separate endpoints with :<|> at the type level,
    -- we separate handlers at the value level (in the same order)
    handlers :: Server UserAPI2
    handlers =
      pure users2
        :<|> pure albert
        :<|> pure isaac