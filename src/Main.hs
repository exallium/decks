{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Applicative
import           Snap.Core
import           Snap.Util.FileServe
import           Snap.Http.Server
import           Network.HTTP.Client
import           Control.Monad.Trans (liftIO)
import           Data.ByteString.Lazy as LBS
import qualified System.IO.Streams as Streams

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop (writeBS "hello world") <|>
    route [ ("foo", writeBS "bar")
          , ("downloadDecks", downloadHandler)
          ] <|>
    dir "static" (serveDirectory ".")

downloader :: Snap LBS.ByteString
downloader = liftIO $ do
    manager <- newManager defaultManagerSettings
    request <- parseUrl "http://www.mtgtop8.com/search"
    response <- httpLbs request manager
    return $ responseBody response

downloadHandler :: Snap ()
downloadHandler = do
    downloader >>= writeLBS
