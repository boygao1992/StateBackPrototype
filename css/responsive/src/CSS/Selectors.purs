module Selectors where

import CSS (Selector)
import CSSUtils (class_)
import ClassNames as CN

-- | id selectors

-- | class selectors

container :: Selector
container = class_ CN.container

logo :: Selector
logo = class_ CN.logo

unstyledList :: Selector
unstyledList = class_ CN.unstyledList

title :: Selector
title = class_ CN.title

button :: Selector
button = class_ CN.button

buttonAccent :: Selector
buttonAccent = class_ CN.buttonAccent

buttonSmall :: Selector
buttonSmall = class_ CN.buttonSmall

column1 :: Selector
column1 = class_ CN.column1

column3 :: Selector
column3 = class_ CN.column3

homeHero :: Selector
homeHero = class_ CN.homeHero

homeAbout :: Selector
homeAbout = class_ CN.homeAbout

homeAboutText :: Selector
homeAboutText = class_ CN.homeAboutText

portfolio :: Selector
portfolio = class_ CN.portfolio

portfolioItem :: Selector
portfolioItem = class_ CN.portfolioItem

portfolioDescription :: Selector
portfolioDescription = class_ CN.portfolioDescription
