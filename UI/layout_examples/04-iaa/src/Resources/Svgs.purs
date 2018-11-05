module Svgs where

import Halogen (HTML, IProp)
import HalogenUtils (svg)
import ClassNames as CN

logo :: forall p r i. Array (IProp r i) -> HTML p i
logo = svg
       CN.logo
       """
	<svg alt="aa" width="190" height="48" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 75.11 19.809">
		<defs>
			<style>
				.cls-1 {
					fill: #4ac6b6;
				}
				.cls-2 {
					fill: none;
				}
				.cls-3 {
					fill: #1a1a1a;
				}
			</style>
		</defs>
		<g id="シンボル_26_1" data-name="シンボル 26 – 1" transform="translate(-45 -33)">
			<path id="パス_3" data-name="パス 3" class="cls-1" d="M2.783,19.809H0V0H2.783Z" transform="translate(45 33)"/>
			<path id="パス_4" data-name="パス 4" class="cls-2" d="M91.033,29.569h6.074L93.51,20.3,90.1,29.092l1.052.175Z" transform="translate(-29.813 15.927)"/>
			<path id="パス_5" data-name="パス 5" class="cls-2" d="M82.938,92l-.238.6Z" transform="translate(-23.669 -44.374)"/>
			<path id="パス_6" data-name="パス 6" class="cls-3" d="M65.919,0H63.476L55.4,19.809h2.884l1.748-4.579h0l.238-.6h0l1.018-2.607h0L64.7,3.227l3.6,9.269H63.476l-.865,2.13h6.515l2.019,5.183h2.867Z" transform="translate(5.389 33)"/>
			<path id="パス_9" data-name="パス 9" class="cls-3" d="M65.919,0H63.476L55.4,19.809h2.884l1.748-4.579h0l.238-.6h0l1.018-2.607h0L64.7,3.227l3.6,9.269H63.476l-.865,2.13h6.515l2.019,5.183h2.867Z" transform="translate(33.692 33)"/>
			<path id="パス_8" data-name="パス 8" class="cls-1" d="M82.7,95.8Z" transform="translate(-23.669 -47.57)"/>
			<path id="パス_10" data-name="パス 10" class="cls-3" d="M2.177,0A2.177,2.177,0,1,1,0,2.177,2.177,2.177,0,0,1,2.177,0Z" transform="translate(115.756 48.24)"/>
		</g>
	</svg>
       """


largeLogo :: forall p r i. Array (IProp r i) -> HTML p i
largeLogo = svg
       CN.largeLogo
       """
		<svg alt="aa" width="190" height="48" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 75.11 19.809">
			<defs>
				<style>
					.cls-1 {
						fill: #4ac6b6;
					}
					.cls-2 {
						fill: none;
					}
					.cls-3 {
						fill: #1a1a1a;
					}
				</style>
			</defs>
			<g id="シンボル_26_1" data-name="シンボル 26 – 1" transform="translate(-45 -33)">
				<path id="パス_3" data-name="パス 3" class="cls-1" d="M2.783,19.809H0V0H2.783Z" transform="translate(45 33)"/>
				<path id="パス_4" data-name="パス 4" class="cls-2" d="M91.033,29.569h6.074L93.51,20.3,90.1,29.092l1.052.175Z" transform="translate(-29.813 15.927)"/>
				<path id="パス_5" data-name="パス 5" class="cls-2" d="M82.938,92l-.238.6Z" transform="translate(-23.669 -44.374)"/>
				<path id="パス_6" data-name="パス 6" class="cls-3" d="M65.919,0H63.476L55.4,19.809h2.884l1.748-4.579h0l.238-.6h0l1.018-2.607h0L64.7,3.227l3.6,9.269H63.476l-.865,2.13h6.515l2.019,5.183h2.867Z" transform="translate(5.389 33)"/>
				<path id="パス_9" data-name="パス 9" class="cls-3" d="M65.919,0H63.476L55.4,19.809h2.884l1.748-4.579h0l.238-.6h0l1.018-2.607h0L64.7,3.227l3.6,9.269H63.476l-.865,2.13h6.515l2.019,5.183h2.867Z" transform="translate(33.692 33)"/>
				<path id="パス_8" data-name="パス 8" class="cls-1" d="M82.7,95.8Z" transform="translate(-23.669 -47.57)"/>
				<path id="パス_10" data-name="パス 10" class="cls-3" d="M2.177,0A2.177,2.177,0,1,1,0,2.177,2.177,2.177,0,0,1,2.177,0Z" transform="translate(115.756 48.24)"/>
			</g>
		</svg>
       """
