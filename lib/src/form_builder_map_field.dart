import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@Deprecated('Please use FormBuilderLocationField widget')
class FormBuilderMapField extends StatefulWidget {
  final String name;
  final List<FormFieldValidator>? validators;
  final CameraPosition? initialValue;
  final bool readonly;
  final InputDecoration decoration;
  final ValueChanged<CameraPosition>? onChanged;
  final ValueTransformer? valueTransformer;

  // final GoogleMapController controller;
  final IconData markerIcon;
  final double markerIconSize;
  final Color markerIconColor;
  final MapType mapType;
  final double height;
  final bool myLocationButtonEnabled; // widget.myLocationButtonEnabled,
  final bool myLocationEnabled; // widget.myLocationEnabled,
  final bool zoomGesturesEnabled; // widget.zoomGesturesEnabled,
  final Set<Marker>? markers; // widget.markers,
  final void Function(LatLng)? onTap; // widget.onTap,
  final EdgeInsets padding; // widget.padding,
  final bool buildingsEnabled; // widget.buildingsEnabled,
  final CameraTargetBounds cameraTargetBounds; // widget.cameraTargetBounds,
  final Set<Circle>? circles; // widget.circles,
  final bool compassEnabled; // widget.compassEnabled,
  final Set<Factory<OneSequenceGestureRecognizer>>?
      gestureRecognizers; // widget.gestureRecognizers,
  final bool indoorViewEnabled; // widget.indoorViewEnabled,
  final bool mapToolbarEnabled; // widget.mapToolbarEnabled,
  final MinMaxZoomPreference
      minMaxZoomPreference; //widget.minMaxZoomPreference,
  final void Function()? onCameraIdle; // widget.onCameraIdle,
  final void Function()? onCameraMoveStarted; // widget.onCameraMoveStarted,
  final void Function(LatLng)? onLongPress; // widget.onLongPress,
  final Set<Polygon>? polygons; // widget.polygons,
  final Set<Polyline>? polylines; // widget.polylines,
  final bool rotateGesturesEnabled; // widget.rotateGesturesEnabled,
  final bool scrollGesturesEnabled; // widget.scrollGesturesEnabled,
  final bool tiltGesturesEnabled; // widget.tiltGesturesEnabled,
  final bool trafficEnabled; // widget.trafficEnabled,

  const FormBuilderMapField({
    Key? key,
    required this.name,
    this.validators,
    this.initialValue,
    this.readonly = false,
    this.decoration = const InputDecoration(),
    this.onChanged,
    this.valueTransformer,
    // this.controller,
    this.markerIcon = Icons.person_pin_circle,
    this.markerIconSize = 30,
    this.markerIconColor = Colors.black,
    this.height = 300,
    this.compassEnabled = true,
    this.mapToolbarEnabled = true,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.mapType = MapType.normal,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = true,
    this.padding = const EdgeInsets.all(0),
    this.indoorViewEnabled = false,
    this.trafficEnabled = false,
    this.buildingsEnabled = true,
    this.markers,
    this.onTap,
    this.circles,
    this.gestureRecognizers,
    this.onCameraIdle,
    this.onCameraMoveStarted,
    this.onLongPress,
    this.polygons,
    this.polylines,
  }) : super(key: key);

  @override
  _FormBuilderMapFieldState createState() => _FormBuilderMapFieldState();
}

class _FormBuilderMapFieldState extends State<FormBuilderMapField> {
  bool _readonly = false;
  final GlobalKey<FormBuilderFieldState> _fieldKey =
      GlobalKey<FormBuilderFieldState>();
  final GlobalKey _markerKey = GlobalKey();
  Completer<GoogleMapController> _controllerCompleter = Completer();
  late FormBuilderState _formState;

  @override
  void initState() {
    super.initState();
    _formState = FormBuilder.of(context)!;
    //_formState.registerField(widget.name, _fieldKey.currentState!);
    _readonly = (_formState.enabled == true) ? true : widget.readonly;
  }

  @override
  Widget build(BuildContext context) {
    // print(_markerKey.currentContext.size);
    return FormField(
      key: _fieldKey,
      enabled: !_readonly,
      initialValue: widget.initialValue,
      validator: (val) {
        for (int i = 0; i < (widget.validators?.length ?? 0); i++) {
          if (widget.validators![i](val) != null)
            return widget.validators![i](val);
        }
        return null;
      },
      onSaved: (val) {
        if (widget.valueTransformer != null) {
          var transformed = widget.valueTransformer!(val);
          FormBuilder.of(context)?.setInternalFieldValue(
            widget.name,
            transformed,
            isSetState: false,
          );
        } else
          _formState.setInternalFieldValue(
            widget.name,
            val,
            isSetState: false,
          );
      },
      builder: (FormFieldState<CameraPosition> field) {
        return InputDecorator(
          decoration: widget.decoration.copyWith(
            enabled: !_readonly,
            errorText: field.errorText,
          ),
          child: Container(
            height: widget.height,
            child: LayoutBuilder(
              builder: (context, constraints) {
                var maxWidth = constraints.biggest.width;
                var maxHeight = constraints.biggest.height;

                return Stack(
                  children: <Widget>[
                    Container(
                      height: maxHeight,
                      width: maxWidth,
                      child: GoogleMap(
                        initialCameraPosition: widget.initialValue ??
                            CameraPosition(
                              target:
                                  LatLng(37.42796133580664, -122.085749655962),
                              zoom: 14.4746,
                            ),
                        onMapCreated: (GoogleMapController controller) {
                          _formState.registerField(
                              widget.name, _fieldKey.currentState!);
                          if (!_controllerCompleter.isCompleted)
                            _controllerCompleter.complete(controller);
                        },
                        onCameraMove: (CameraPosition newPosition) {
                          field.didChange(newPosition);
                          if (widget.onChanged != null)
                            widget.onChanged!(newPosition);
                        },
                        mapType: widget.mapType,
                        myLocationButtonEnabled: widget.myLocationButtonEnabled,
                        myLocationEnabled: widget.myLocationEnabled,
                        zoomGesturesEnabled: widget.zoomGesturesEnabled,
                        markers: widget.markers ?? {},
                        onTap: widget.onTap,
                        padding: widget.padding,
                        buildingsEnabled: widget.buildingsEnabled,
                        cameraTargetBounds: widget.cameraTargetBounds,
                        circles: widget.circles ?? {},
                        compassEnabled: widget.compassEnabled,
                        gestureRecognizers: widget.gestureRecognizers ?? {},
                        indoorViewEnabled: widget.indoorViewEnabled,
                        mapToolbarEnabled: widget.mapToolbarEnabled,
                        minMaxZoomPreference: widget.minMaxZoomPreference,
                        onCameraIdle: widget.onCameraIdle,
                        onCameraMoveStarted: widget.onCameraMoveStarted,
                        onLongPress: widget.onLongPress,
                        polygons: widget.polygons ?? {},
                        polylines: widget.polylines ?? {},
                        rotateGesturesEnabled: widget.rotateGesturesEnabled,
                        scrollGesturesEnabled: widget.scrollGesturesEnabled,
                        tiltGesturesEnabled: widget.tiltGesturesEnabled,
                        trafficEnabled: widget.trafficEnabled,
                      ),
                    ),
                    Positioned(
                      bottom: maxHeight / 2,
                      right: (maxWidth - widget.markerIconSize) / 2,
                      child: Container(
                        key: _markerKey,
                        child: Icon(
                          widget.markerIcon,
                          size: widget.markerIconSize,
                          color: widget.markerIconColor,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
