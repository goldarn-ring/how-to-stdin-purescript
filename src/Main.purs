module Main where

import Prelude
import Data.Either (Either(..))
import Node.ReadLine (createConsoleInterface, noCompletion, setPrompt, prompt, setLineHandler, close)
import Effect.Aff (Aff, Canceler, makeAff, launchAff_, effectCanceler)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Exception (Error)
import Effect.Console (log)

readLine :: Aff String
readLine = makeAff handler
  where
    handler :: (Either Error String -> Effect Unit) -> Effect Canceler
    handler next = do
      interface <- createConsoleInterface noCompletion
      setPrompt "> " 2 interface
      prompt interface
      setLineHandler interface \str -> do
        close interface
        next $ Right str
      pure $ effectCanceler $ close interface

foreign import readLineSync :: Effect String

main :: Effect Unit
main = do
  askNameSync
  askNameAsync

askNameAsync :: Effect Unit
askNameAsync = launchAff_ do
  liftEffect $ log "(Async) Hello. What is your name?" 
  name <- readLine
  liftEffect $ log $ "Hello, " <> name

askNameSync :: Effect Unit
askNameSync = do
  log "(Sync) Hello. What is your name?"
  name <- readLineSync
  log $ "Hello, " <> name
