{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Neuron.Zettelkasten.Query.ThemeSpec
  ( spec,
  )
where

import Neuron.Zettelkasten.Query.Theme
import Relude
import Test.Hspec
import Util

spec :: Spec
spec =
  describe "Link theme extraction from URI" $ do
    it "Parse basic link theme" $ do
      parseURIWith linkThemeFromURI "zquery://search?linkTheme=default"
        `shouldBe` Right LinkTheme_Default
      parseURIWith linkThemeFromURI "zquery://search?linkTheme=withDate"
        `shouldBe` Right LinkTheme_WithDate
      parseURIWith linkThemeFromURI "zcfquery://search?linkTheme=simple"
        `shouldBe` Right LinkTheme_Simple
    it "Parse grouped query flag" $ do
      parseURIWith zettelsViewFromURI "zquery://search?tag=foo&grouped"
        `shouldBe` Right (ZettelsView LinkTheme_Default True)
      parseURIWith zettelsViewFromURI "zquery://search?tag=foo"
        `shouldBe` Right (ZettelsView LinkTheme_Default False)
