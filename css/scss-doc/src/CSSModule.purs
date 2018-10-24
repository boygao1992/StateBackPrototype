module CSSModule where


import Prelude

import CSS (CSS)
import Styles as Styles

-- | Root
root :: CSS
root = do
  Styles.nestedRules1

  Styles.nestedRules2

  Styles.refParentSelectors1

  Styles.refParentSelectors2

  Styles.refParentSelectors3

  Styles.nestedProperties

  Styles.error
  Styles.seriousError

  Styles.error_
  Styles.attention
  Styles.seriousError_

  Styles.error_
  Styles.seriousError__
  Styles.criticalError

  Styles.hyperLink
  Styles.fakeLinks
