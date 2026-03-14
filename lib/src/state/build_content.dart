part of '../../panel_frame.dart';

extension _BuildContent on _PanelFrameState {
  Widget buildContent(BuildContext context) {
    /// used twice: in the frame layout itself and on top of the top bar but
    /// animated with an extra opacity layer to cover it only when showing alerts
    final barrier = _Barrier(
      style: style,
      controller: _panelAnimation,
      closePanel: closePanel,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        if (_isShowingAlert.value) {
          previousAlert();
          return;
        }
        if (_panelAnimation.value > 0) {
          closePanel();
          return;
        }
        final navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.pop();
        } else {
          SystemNavigator.pop();
        }
      },
      child: CleanProvider(
        data: this,
        child: _Frame(
          style: style,
          barrier: barrier,
          body: _Body(
            style: style,
            controller: _panelAnimation,
            child: widget.body,
          ),
          bottomBar: _BottomBar(
            style: style,
            content: widget.bottomBar,
            onDragEnd: _onDragEnd,
            onDragUpdate: _onDragUpdate,
          ),
          topBar: _TopBar(
            panelAnimation: _panelAnimation,
            topBarBuilder: widget.topBarBuilder,
            topBarChild: widget.topBarChild,
            barrier: barrier,
            style: style,
            alerts: _alerts,
            isAnimatingBack: _isAnimatingBack,
            openedFirstAlertFromExpandedPanel:
                _openedFirstAlertFromExpandedPanel,
          ),
          panel: _DecoratedPanel(
            style: style,
            alertsHeightsUpdate: _alertsSizesChanged,
            alertsHeightUpdate: (v) {
              _alertsHeight = v;
            },
            panelAnimation: _panelAnimation,
            alerts: _alerts,
            isAnimatingBack: _isAnimatingBack,
            neededTopSafeAreas: _alertsInternalTopViewPaddings,
            openedFirstAlertFromExpandedPanel:
                _openedFirstAlertFromExpandedPanel,
            onDragEnd: _onDragEnd,
            onDragUpdate: _onDragUpdate,
            scrollBehavior: ScrollConfiguration.of(
              context,
            ).copyWith(physics: panelContentScrollPhysics),
            expandedPanelContent: _ExpandedPanelContents(
              style: style,
              child: widget.expandedPanel,
            ),
            collapsedPanel: _CollapsedPanel(
              style: style,
              content: widget.collapsedPanel,
              snackBar: _SnackBar(
                snackBar: _snackBar,
                snackbarAnimation: _snackbarAnimation,
                curve: _snackBarCurve,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
