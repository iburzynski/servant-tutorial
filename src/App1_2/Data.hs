{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module App1_2.Data where

import Data.Aeson (ToJSON)
import Data.Time.Calendar (Day, fromGregorian)
import GHC.Generics (Generic)

data User = User
  { name :: String,
    age :: Int,
    email :: String,
    registration_date :: Day
  }
  deriving (Eq, Show, Generic, ToJSON)

-- App1
users1 :: [User]
users1 =
  [ isaac,
    albert
  ]

-- App2
isaac :: User
isaac = User "Isaac Newton" 372 "isaac@newton.co.uk" (fromGregorian 1683 3 1)

albert :: User
albert = User "Albert Einstein" 136 "ae@mc2.org" (fromGregorian 1905 12 1)

users2 :: [User]
users2 = users1