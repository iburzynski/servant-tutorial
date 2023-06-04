module Server3.Data where

import Data.Aeson (FromJSON, ToJSON)
import Data.List (intercalate)
import GHC.Generics (Generic)

data Position = Position
  { xCoord :: Int,
    yCoord :: Int
  }
  deriving (Show, Generic, FromJSON, ToJSON)

newtype HelloMessage = HelloMessage {msg :: String}
  deriving (Show, Generic, FromJSON, ToJSON)

data ClientInfo = ClientInfo
  { clientName :: String,
    clientEmail :: String,
    clientAge :: Int,
    clientInterestedIn :: [String]
  }
  deriving (Show, Generic, FromJSON, ToJSON)

data Email = Email
  { from :: String,
    to :: String,
    subject :: String,
    body :: String
  }
  deriving (Show, Generic, FromJSON, ToJSON)

emailForClient :: ClientInfo -> Email
emailForClient c = Email from' to' subject' body'
  where
    from' = "great@company.com"
    to' = clientEmail c
    subject' = "Hey " ++ clientName c ++ ", we miss you!"
    body' =
      concat
        [ "Hi ",
          clientName c,
          ",\n\n",
          "Since you've recently turned ",
          show (clientAge c),
          ", have you checked out our latest ",
          intercalate ", " (clientInterestedIn c),
          " products? Give us a visit!"
        ]

newtype FileContent = FileContent {content :: String}
  deriving (Show, Generic, FromJSON, ToJSON)