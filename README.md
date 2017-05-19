# Lightcurve Classification for Periodic Sources using the Catalina Real-Time Transients Survey (CRTS)

## Team Members
@kvmu
@rdegardner
@rachzili13
@yaoshi1994
@brooke1313

## Abstract
We present a small study in the classification of (periodic)
stars from the [CRTS dataset](https://arxiv.org/abs/1405.4290). Using a Random Forest classifier we achieved a
81.59% classification accuracy on 16 classes of stars.

Raw lightcurve data was analyzed to extract features using the [FATS](http://isadoranun.github.io/tsfeat/FeaturesDocumentation.html) module (Feature Analysis for Time Series), developed by Isadora Nun (github: @isadoranunand) Pavlos Protopapas from the Institute of Applied Computational Science. This is the FATS [paper](https://arxiv.org/pdf/1506.00010.pdf).

The classes of stars that we considered were, see [paper](https://arxiv.org/abs/1405.4290):
- ACEP
- Beta-Lyrae
- Blazhko
- Cep II
- EA
- ELL
- EW
- HADS
- Hump
- LADS
- LPV
- PCEB
- RRab
- RRc
- RRd
- RS CVn
