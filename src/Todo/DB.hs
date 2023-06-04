-- Required extensions for Persistent
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

module Todo.DB where

import Control.Monad.Logger
import Control.Monad.Reader (ReaderT)
import Control.Monad.Trans.Resource (ResourceT, runResourceT)
import Database.Persist.Sqlite (SqlBackend, runSqlConn, withSqliteConn)
import qualified Database.Persist.Sqlite as SQL
import Database.Persist.TH
  ( mkMigrate,
    mkPersist,
    persistLowerCase,
    share,
    sqlSettings,
  )

share
  [mkPersist sqlSettings, mkMigrate "migrateAll"]
  [persistLowerCase|
Todo
    title String
    completed Bool
    priority Int
    deriving Show
|]

type DBContext = ResourceT (NoLoggingT IO)

runDb :: ReaderT SqlBackend DBContext a -> IO a
runDb = runNoLoggingT . runResourceT . withSqliteConn "dev.sqlite3" . runSqlConn

migrateAndRunDb :: IO ()
migrateAndRunDb = runDb $ SQL.runMigration migrateAll