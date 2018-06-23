# idea

Deprecate mouse. Full keyboard control in 2D GUI.

# Modes

## 1. Classic Mode

Discretize the screen space into grids.

Select specific grid by label.
e.g. 2 letters can cover 26^2 = 676 grids

|     | a  | b  | c  | d  | ... | z  |
|-----|----|----|----|----|-----|----|
| a   | aa | ab | ac | ad |     | az |
| b   | ba | bb | bc | bd |     | bz |
| ... |    |    |    |    |     |    |
| z   | za | zb | zc | zd |     | zz |

By default, a mouse click event will be triggered at the center of the grid.
i.e. left/middle/right single/double/hold click

### Granulity Control
(global scale) Able to increase/decrease the resolution of grid system.

(local scale) The selected grid can be further discretized.

## 2. Widget-oriented Auto Mode

Automatically detect and highlight interactable/input components on the screen.
(primarily buttons, slider maybe)

Components will be labeled the same way as in classic mode.
(hopefully way less number of items)

The number of interactable components on screen can be further restricted to current focused window.

Region/Object detection: R-CNN (supervised learning).
Since this is a binary classification task (interactable, non-interactable), it should perform extremely well. 

### (Semi-)Automated labeling

Able to be adapted to personal environments by a learning/calibration phase where users conduct their routine work flow as normal and the learning occurs behind the scene.

Targeted users are not required to have any knowledge about the learning algorithm, in another word, they don't expect manually labeling the regions on screen.

For advanced users, to have better accuracy, they can intercept the learning process and provide their knowledge about the UI.
For example, they can check the components currently being detected on the screen and adjust their bounding boxs, or mark some of the incorrectly labeled region as non-interactble.

Basic procedure:
- Anytime user triggers a mouse event, record the screen (or surrounding region close to the place where the event occurs) in next couple of seconds.
- Determine if any state transition happens in the system. (ignore meaningless clicks on non-interactable region)
- If so, stored the images of the region and label them as interactable.

Potential problems
- User fires mouse events too fast: the recording system may fail

### Brain Computer Interface 

[EMOTIV EPOC+ 14 Channel Mobile EEG](https://www.emotiv.com/product/emotiv-epoc-14-channel-mobile-eeg/)

[Youtube - Brain Controlled Javascript - JSConf 2018](https://www.youtube.com/watch?v=7KhFO-qCVyg&t=252s)

Cursor navigation by {Up, Down, Left, Right} is enough for component selection. 
Control by EEG signal is possible.

May narrow the focused region by gaze tracking.

# Tool

1.[Detectron - FAIR's research platform for object detection research, implementing popular algorithms like Mask R-CNN and RetinaNet](https://github.com/facebookresearch/Detectron)

2.[OpenCV - image processing](https://opencv.org/)

3.[Qt - cross-platform application framework](https://doc.qt.io/)
