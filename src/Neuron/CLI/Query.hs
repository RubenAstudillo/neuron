{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Neuron.CLI.Query
  ( queryZettelkasten,
  )
where

import Data.Aeson
import qualified Data.Aeson.Text as Aeson
import Data.Some
import Data.TagTree (tagTree)
import Data.Tree (Tree (..))
import Development.Shake (Action)
import qualified Neuron.Zettelkasten.Graph as G
import Neuron.Zettelkasten.ID (zettelIDSourceFileName)
import Neuron.Zettelkasten.Query (Query (..), runQuery)
import Neuron.Zettelkasten.Zettel (Zettel (..), zettelJson)
import Relude
import qualified Rib
import System.FilePath

queryZettelkasten :: FilePath -> Some Query -> Action ()
queryZettelkasten notesDir query = do
  zettels <- fmap (fmap fst . snd) . G.loadZettelkasten =<< Rib.forEvery ["*.md"] pure
  case query of
    Some (Query_ZettelByID zid) -> do
      let res = runQuery zettels (Query_ZettelByID zid)
      putLTextLn $ Aeson.encodeToLazyText $ zettelJsonWith <$> res
    Some (Query_ZettelsByTag pats) -> do
      let res = runQuery zettels (Query_ZettelsByTag pats)
      putLTextLn $ Aeson.encodeToLazyText $ zettelJsonWith <$> res
    Some (Query_Tags pats) -> do
      let tags = runQuery zettels (Query_Tags pats)
      putLTextLn $ Aeson.encodeToLazyText $ toJSON $ fmap treeToJson (tagTree tags)
  where
    -- TODO: Use newtype wrapper and write ToJSON
    treeToJson (Node (tag, count) children) =
      object
        [ "name" .= tag,
          "count" .= count,
          "children" .= fmap treeToJson children
        ]
    zettelJsonWith z@Zettel {..} =
      object $
        [ "path" .= (notesDir </> zettelIDSourceFileName zettelID)
        ]
          <> zettelJson z
