module Request
    ( getHeroes
	, getHeroesWin
	, getHeroesStats
    ) where


import HeroesParser
import JSON
import HeroesDatabase
import GHC.Int
import Data.Text (pack)
import Data.Conduit.Binary (sinkFile) -- Exported from the package conduit-extra
import qualified Data.ByteString.Lazy.Internal as L
import qualified Data.ByteString as B
import Network.HTTP.Conduit
import Network.HTTP.Types.Status (statusCode)
import Conduit (runConduit, (.|))
import Control.Monad.Trans.Resource (runResourceT)
import Control.Monad.IO.Class
import qualified Control.Exception as E
import Data.Time.Clock
import Data.Time.Calendar
import qualified Data.ByteString as D
import Network.HTTP.Req
	

--URLS
baseurl :: String 
baseurl = "https://api.opendota.com/api/"

HeroURL :: String
HeroURL = baseurl+"/heroes"
 
 --Enter the name of the hero and you will get the url required to get heroStats
HeroStatsURL :: String -> String
HeroStatsURL x = baseurl ++ getHeroId x ++ "/matches"



--returns all heores

getHeroes :: IO L.ByteString

getHeroes = runReq def $ do
       r <- req GET -- method
       (https (baseurl+hero) /: "get") -- safe by construction URL
       --ReqBody takes a From jason instance which haskell has constructed for us 
       (ReqBodyJson Hero) -- use built-in options or add your own
       jsonResponse -- we want a json response naturally
       mempty       -- This part holds additional options we dont need  



--you enter hero id which you can get from getHeroId and will perform a get to return stats
getHeroesStats :: Int -> IO L.ByteString

  getHeroesStats x = runReq def $ do
       r <- req GET -- method
       (https (baseurl+hero) /: "get") -- safe by construction URL
       --ReqBody takes a From jason instance which haskell has constructed for us 
       (ReqBodyJson HeroStats) -- use built-in options or add your own
       jsonResponse -- we want a json response naturally
       mempty       -- This part holds additional options we dont need  

getHeroId :: String -> Int 

getHeroId x | x=="Axe" = return 1
            | x=""     = return 2



