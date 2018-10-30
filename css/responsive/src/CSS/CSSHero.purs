module CSSHero where


import Prelude

import CSS (CSS)
import CSS (backgroundImage, backgroundPosition, backgroundSize, color, cover, em, height, nil, paddingTop, placed, sideCenter, url, vh) as CSS
import CSSUtils ((?))
import CSSUtils (padding2) as CSS
import Colors as Colors
import Selectors as S
import Urls (heroBackground) as Urls
import CSSConfig (desktop)

root :: CSS
root = do
  S.homeHero ? do
    CSS.backgroundImage (CSS.url Urls.heroBackground)
    CSS.backgroundSize CSS.cover
    CSS.backgroundPosition $ CSS.placed CSS.sideCenter CSS.sideCenter
    CSS.padding2 (CSS.em 10.0) CSS.nil
    CSS.color Colors.white

  desktop do
    S.homeHero ? do
      CSS.height (CSS.vh 100.0)
      CSS.paddingTop (CSS.vh 35.0)
