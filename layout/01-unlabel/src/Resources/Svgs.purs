module Svgs where

import SvgFiles as SvgFiles

preloaderLogo :: String
preloaderLogo =
  """
    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
          width="100px" height="60px" viewBox="0 0 35.5 35.5" enable-background="new 0 0 35.5 35.5" xml:space="preserve">
    <path fill="#010101" d="M17.7,0C7.9,0,0,7.9,0,17.7c0,9.8,7.9,17.7,17.7,17.7c9.8,0,17.7-7.9,17.7-17.7C35.5,7.9,27.5,0,17.7,0z
          M27.9,23.9h-8v-6.1l-8.6,9.7l-1.9-1.6l3.2-3.9C10,22,7.9,20.5,7.9,17.6v-6.6h3v6.6c0,1.3,0.7,2,2,2c1.3,0,2-0.7,2-2v-6.6h3v5.4
        L25,8l2,1.6l-4.1,4.8v7.6h5V23.9z"/>
    </svg>
  """

logoFull :: String
logoFull = SvgFiles.logo_full

logoDark :: String
logoDark = SvgFiles.logo_dark

logoLight :: String
logoLight = SvgFiles.logo_light

