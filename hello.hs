{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}

module Main where

import Control.Applicative ((<$>), optional)
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import Data.Text.Lazy (unpack)
import Happstack.Lite
import Text.Blaze.Html5 (Html, (!), a, form, input, p, toHtml, label)
import Text.Blaze.Html5.Attributes (action, enctype, href, name, size, type_, value)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

main :: IO ()
main = serve Nothing myApp

myApp :: ServerPart Response
myApp = msum
  [ dir "echo"    $ echo
    ,dir "aunt"   $ aunt
    ,dir "trump"  $ trump
    ,homePage  
  ]

template :: Text -> Html -> Response
template title body = toResponse $
    H.html $ do
        H.head $ do
            H.title (toHtml title)
        H.body $ do
            body
            p $ a ! href "/" $ "back home"

homePage :: ServerPart Response
homePage =
    ok $ template "home page" $ do
        H.h1 "Hello!"
        H.p "Writting application"
        H.p $ a ! href "/echosecret%20message" $ "echo"
        H.p $ a ! href "/query?foo=bar" $ "query parameters"
        H.p $ a ! href "/form" $ "upload bitch!"
        H.p $ a ! href "/trump" $ "Picture of Donald Trump"
        H.p $ a ! href "/aunt" $ "Aunt"

echo :: ServerPart Response 
echo = 
    path $ \(msg :: String) -> 
        ok $ template "echo" $ do
            p $ "echo says: " >> toHtml msg
            p "Change the url to echo something else"

aunt :: ServerPart Response
aunt = 
    ok $ template "home page" $ do        
        H.iframe ! A.src "https://www.youtube.com/embed/SjZUbCpIi_U" $ ""


trump :: ServerPart Response
trump = 
  ok $ template "home page" $ do
      H.img ! A.src "http://static6.businessinsider.com/image/55918b77ecad04a3465a0a63/nbc-fires-donald-trump-after-he-calls-mexicans-rapists-and-drug-runners.jpg"

