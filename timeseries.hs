import Distribution.Simple.CCompiler (filenameCDialect)
import Text.Read (readEither)

-- Dager er inklusive i begge ender
-- { start: 1, end: 5 } = 5 hele dager, 1, 2, 3, 4, 5
data TimeRange = TimeRange
  { start :: Int,
    end :: Int
  }
  deriving (Show, Read, Eq)

-- Vi lurer på om personen har vært sykmeldt i 6 uker eller mer (42 dager)
-- UTEN et opphold på 16 dager eller mer.
--
-- F.eks:
-- Sykmeldt i 30 dager, også friskmeldt i 14 dager, også sykmeldt i 30 dager = true
-- Sykmeldt i 30 dager, også friskmeldt i 16 dager, også sykmeldt i 30 dager = false
-- Syk i 10 dager, frisk i 10, syk i 10, frisk i 10, syk i 10 er et reknet
--   som "sammenhengende" syk i 50 dager, med ingen opphold over 16 dager = true
continuouslySick :: Int -> Int -> [TimeRange] -> Bool
continuouslySick weeks allowedGap _ = False

hasBeencontinuouslySickFor6Weeks :: [TimeRange] -> Bool
hasBeencontinuouslySickFor6Weeks = continuouslySick 6 16

main = do
  case1 <- readFile "data1.txt"
  case2 <- readFile "data2.txt"
  case3 <- readFile "data3.txt"
  case4 <- readFile "data4.txt"

  print $ map (fmap hasBeencontinuouslySickFor6Weeks . parseTimeRange) [case1, case2, case3, case4]
  where
    -- readEither brukes så vi får feilen i outputten om man har feil struktur på data-filenameCDialect
    parseTimeRange :: String -> Either String [TimeRange]
    parseTimeRange = readEither
