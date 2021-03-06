{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Neuron.Zettelkasten.Graph.Type
  ( -- * Graph type
    ZettelGraph,
  )
where

import Data.Graph.Labelled
import Neuron.Zettelkasten.Connection
import Neuron.Zettelkasten.Zettel

-- | The Zettelkasten graph
type ZettelGraph = LabelledGraph Zettel [Connection]
