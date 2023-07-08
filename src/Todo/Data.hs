{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE InstanceSigs #-}

module Todo.Data where

import Control.Monad.Reader (ReaderT, mzero)
import Data.Aeson
import Data.Aeson.Types (Parser)
import Data.Maybe (catMaybes, fromMaybe)
import Database.Persist.Sqlite (Update, (=.))
import GHC.Generics (Generic)
import Servant (Handler)
import Todo.DB (EntityField (..), Todo (Todo), TodoId)
import Utils (URLRoot)

type AppM = ReaderT URLRoot Handler

data Priority = Low | Medium | High
  deriving (Show, Eq, Ord, Enum, Generic, FromJSON, ToJSON)

data TodoResponse = TodoResponse
  { trId :: TodoId,
    trUrl :: String,
    trTitle :: String,
    trCompleted :: Bool,
    trPriority :: Priority
  }
  deriving (Show)

instance ToJSON TodoResponse where
  toJSON :: TodoResponse -> Value
  toJSON (TodoResponse i u t c p) =
    object
      [ "id" .= i,
        "url" .= u,
        "title" .= t,
        "completed" .= c,
        "priority" .= p
      ]

instance FromJSON TodoResponse where
  parseJSON :: Value -> Parser TodoResponse
  parseJSON (Object o) =
    TodoResponse
      <$> o
      .: "id"
      <*> o
      .: "url"
      <*> o
      .: "title"
      <*> o
      .: "completed"
      <*> o
      .: "priority"
  parseJSON _ = mzero

data TodoAction = TodoAction
  { taTitle :: Maybe String,
    taCompleted :: Maybe Bool,
    taPriority :: Maybe Priority
  }
  deriving (Show)

instance FromJSON TodoAction where
  parseJSON :: Value -> Parser TodoAction
  parseJSON (Object o) =
    TodoAction
      <$> o .:? "title"
      <*> o .:? "completed"
      <*> o .:? "priority"
  parseJSON _ = mzero

instance ToJSON TodoAction where
  toJSON :: TodoAction -> Value
  toJSON (TodoAction mT mC mP) =
    noNullsObject
      [ "title" .= mT,
        "completed" .= mC,
        "priority" .= mP
      ]
    where
      noNullsObject = object . filter notNull
      notNull (_, Null) = False
      notNull _ = True

actionToTodo :: TodoAction -> Todo
actionToTodo (TodoAction mTitle mCompleted mPriority) = Todo title completed priority
  where
    title = fromMaybe "" mTitle
    completed = fromMaybe False mCompleted
    priority = fromEnum $ fromMaybe Low mPriority

actionToUpdates :: TodoAction -> [Update Todo]
actionToUpdates (TodoAction mT mC mP) =
  catMaybes
    [ (TodoTitle =.) <$> mT,
      (TodoCompleted =.) <$> mC,
      (TodoPriority =.) . fromEnum <$> mP
    ]
