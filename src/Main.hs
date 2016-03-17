{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Applicative
import           Snap.Core
import           Snap.Util.FileServe
import           Snap.Http.Server
import           Control.Monad.Trans (liftIO)
import           Data.ByteString as BS
import           Data.ByteString.Char8 as Char8
import           Text.XML.HXT.Core
import           Text.HandsomeSoup

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop (writeBS "hello world") <|>
    route [ ("downloadDecks", downloadHandler) ] <|>
    dir "static" (serveDirectory ".")

downloader :: Snap BS.ByteString
downloader = liftIO $ do
    let doc = fromUrl "http://www.mtgtop8.com/search"
    links <- runX $ doc >>> css "td.S11 a" ! "href"
    return $ BS.concat [Char8.pack $ "www.mtgtop8.com/" ++ x ++ "\n" | x <- links]

downloadHandler :: Snap ()
downloadHandler = do
    downloader >>= writeBS
