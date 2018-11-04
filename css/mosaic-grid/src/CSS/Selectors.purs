module Selectors where

import CSS (Selector)
import CSSUtils (class_)
import ClassNames as CN

sidebar :: Selector
sidebar = class_ CN.sidebar

logo :: Selector
logo = class_ CN.logo

navItem :: Selector
navItem = class_ CN.navItem

content :: Selector
content = class_ CN.content

portfolio :: Selector
portfolio = class_ CN.portfolio

portfolioItem :: Selector
portfolioItem = class_ CN.portfolioItem

small :: Selector
small = class_ CN.small

medium :: Selector
medium = class_ CN.medium

large :: Selector
large = class_ CN.large

tall :: Selector
tall = class_ CN.tall

wide :: Selector
wide = class_ CN.wide

two :: Selector
two = class_ CN.two

active :: Selector
active = class_ CN.active
