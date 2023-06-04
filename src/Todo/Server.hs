{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Avoid lambda" #-}
module Todo.Server where
import Control.Monad.Except
import Control.Monad.Reader (MonadReader (ask), runReaderT)
import Data.Proxy
import qualified Data.Text as Text
import Database.Persist.Sqlite (Entity (..), SqlBackend)
import qualified Database.Persist.Sqlite as SQL
import Servant
import Todo.DB (DBContext, Todo (..), runDb)
import Todo.Data
import Todo.Middleware (applyMiddleware)
import Web.PathPieces (toPathPiece)

-- describe API as a union of request endpoints
type API =
  "todos" :> Get '[JSON] [TodoResponse]
    :<|> "todos" :> Delete '[JSON] ()
    :<|> "todos" :> ReqBody '[JSON] TodoAction :> PostCreated '[JSON] TodoResponse
    :<|> "todos" :> Capture "todoid" Integer :> Get '[JSON] TodoResponse
    :<|> "todos" :> Capture "todoid" Integer :> Delete '[JSON] ()
    :<|> "todos" :> Capture "todoid" Integer :> ReqBody '[JSON] TodoAction :> Patch '[JSON] TodoResponse

handlers :: ServerT API AppM
handlers =
  getTodos
    :<|> deleteTodos
    :<|> postTodo
    :<|> getTodo
    :<|> deleteTodo
    :<|> patchTodo

toResp :: Entity Todo -> AppM TodoResponse
toResp (Entity key (Todo t c p)) = do
  urlRoot <- ask
  let u =
        concat
          [ urlRoot,
            "/todos/",
            Text.unpack (toPathPiece key)
          ]
  pure $ TodoResponse key u t c (toEnum p)

toRespList :: [Entity Todo] -> AppM [TodoResponse]
toRespList = traverse toResp

getTodos :: AppM [TodoResponse]
getTodos = do
  todos <- liftIO $ runDb $ SQL.selectList @Todo [] []
  toRespList todos

deleteTodos :: AppM ()
deleteTodos = liftIO $ runDb $ SQL.deleteWhere @SqlBackend @DBContext @Todo []

getTodo :: Integer -> AppM TodoResponse
getTodo tId = do
  let tKey = SQL.toSqlKey (fromIntegral tId)
  mtodo <- liftIO $ runDb $ SQL.get tKey
  maybe (throwError err404) (\todo -> toResp (Entity tKey todo)) mtodo

deleteTodo :: Integer -> AppM ()
deleteTodo tId = do
  let tKey = SQL.toSqlKey @Todo (fromIntegral tId)
  liftIO $ runDb $ SQL.delete tKey

postTodo :: TodoAction -> AppM TodoResponse
postTodo todoAct = do
  let todo = actionToTodo todoAct
  tId <- liftIO $ runDb $ SQL.insert todo
  toResp $ SQL.Entity tId todo

patchTodo :: Integer -> TodoAction -> AppM TodoResponse
patchTodo tId todoAct = do
  let tKey = SQL.toSqlKey (fromIntegral tId)
      updates = actionToUpdates todoAct
  todo <- liftIO $ runDb $ SQL.updateGet tKey updates
  toResp $ Entity tKey todo

server :: URLRoot -> Server API
server urlRoot = hoistServer @API Proxy appMToHandler handlers
  where
    -- natural transformation to convert our App monad to Handler monad
    appMToHandler :: AppM a -> Handler a
    appMToHandler appMa = (runReaderT appMa) urlRoot

todoApp :: URLRoot -> Application
todoApp urlRoot = applyMiddleware $ serve @API Proxy (server urlRoot)