
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Server1_2.Server1 where

import Servant
import Server1_2.Data


type UserAPI1 = "users" :> Get '[JSON] [User]

-- Server api --> ServerT api Handler
server1 :: Server UserAPI1
server1 = pure users1

-- type ServerT (path :> api) Handler = ServerT api Handler
-- type ServerT (Verb method status ctypes a) Handler = Handler a

-- newtype Handler a = Handler { 
--   runHandler' :: ExceptT ServerError IO a
-- }

-- Create proxy to guide type inference:
-- Proxy is a type that holds no data, but has a phantom parameter of arbitrary type. 
-- It's used as a placeholder value to provide type information, despite the type not being used at the value level.
-- We can provide type information without requiring an actual value of that type.
userAPIproxy :: Proxy UserAPI1
userAPIproxy = Proxy

app1 :: Application
app1 = serve userAPIproxy server1