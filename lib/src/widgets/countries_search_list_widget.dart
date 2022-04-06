import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/device_utils.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

/// Creates a list of Countries with a search textfield.
class CountrySearchListWidget extends StatefulWidget {
  final List<Country> countries;
  final InputDecoration? searchBoxDecoration;
  final String? locale;
  final ScrollController? scrollController;
  final bool autoFocus;
  final bool? showFlags;
  final bool? useEmoji;
  final Widget searchIcon;
  final Color cursorColor;
  final TextStyle countryNameTextStyle;
  final TextStyle countryCodeTextStyle;
  final Function(Country country) setCountry;

  CountrySearchListWidget(
    this.countries,
    this.locale, {
    this.searchBoxDecoration,
    this.scrollController,
    this.showFlags,
    this.useEmoji,
    this.autoFocus = false,
    required this.searchIcon,
    required this.cursorColor,
    required this.countryNameTextStyle,
    required this.countryCodeTextStyle,
    required this.setCountry,
  });

  @override
  _CountrySearchListWidgetState createState() =>
      _CountrySearchListWidgetState();
}

class _CountrySearchListWidgetState extends State<CountrySearchListWidget> {
  late TextEditingController _searchController = TextEditingController();
  late List<Country> filteredCountries;

  @override
  void initState() {
    final String value = _searchController.text.trim();
    filteredCountries = Utils.filterCountries(
      countries: widget.countries,
      locale: widget.locale,
      value: value,
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Returns [InputDecoration] of the search box
  InputDecoration getSearchBoxDecoration() {
    return widget.searchBoxDecoration ??
        InputDecoration(labelText: 'Search by country name or dial code');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        //   child: TextFormField(
        //     key: Key(TestHelper.CountrySearchInputKeyValue),
        //     decoration: getSearchBoxDecoration(),
        //     controller: _searchController,
        //     autofocus: widget.autoFocus,
        //     onChanged: (value) {
        //       final String value = _searchController.text.trim();
        //       return setState(
        //         () => filteredCountries = Utils.filterCountries(
        //           countries: widget.countries,
        //           locale: widget.locale,
        //           value: value,
        //         ),
        //       );
        //     },
        //   ),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.searchIcon,
            Flexible(
              child: TextFormField(
                key: Key(TestHelper.CountrySearchInputKeyValue),
                decoration: getSearchBoxDecoration(),
                controller: _searchController,
                autofocus: widget.autoFocus,
                cursorColor: widget.cursorColor,
                onChanged: (value) {
                  final String value = _searchController.text.trim();
                  return setState(
                    () => filteredCountries = Utils.filterCountries(
                      countries: widget.countries,
                      locale: widget.locale,
                      value: value,
                    ),
                  );
                },
              ),
            )
          ],
        ),
        Divider(
          height: 1,
          color: blackColor,
          thickness: setCurrentWidth(0.4, context),
        ),
        Flexible(
          child: ListView.builder(
            controller: widget.scrollController,
            shrinkWrap: true,
            itemCount: filteredCountries.length,
            itemBuilder: (BuildContext context, int index) {
              Country country = filteredCountries[index];

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: setCurrentWidth(25, context),
                        right: setCurrentWidth(68, context),
                      ),
                      child: DirectionalCountryListTile(
                        setCountry: (val) {
                          widget.setCountry(val);
                        },
                        country: country,
                        locale: widget.locale,
                        showFlags: widget.showFlags!,
                        useEmoji: widget.useEmoji!,
                        countryNameTextStyle: widget.countryNameTextStyle,
                        countryCodeTextStyle: widget.countryCodeTextStyle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: setCurrentWidth(27, context),
                      right: setCurrentWidth(27, context),
                    ),
                    child: Divider(
                      height: 1,
                      color: blackColor,
                      thickness: setCurrentWidth(0.4, context),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class DirectionalCountryListTile extends StatelessWidget {
  final Country country;
  final String? locale;
  final bool showFlags;
  final bool useEmoji;
  final TextStyle countryNameTextStyle;
  final TextStyle countryCodeTextStyle;
  final Function(Country country) setCountry;

  const DirectionalCountryListTile({
    Key? key,
    required this.country,
    required this.locale,
    required this.showFlags,
    required this.useEmoji,
    required this.countryNameTextStyle,
    required this.countryCodeTextStyle,
    required this.setCountry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
      leading: (showFlags ? _Flag(country: country, useEmoji: useEmoji) : null),
      title: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                '${Utils.getCountryName(country, locale)}',
                textDirection: Directionality.of(context),
                textAlign: TextAlign.start,
                style: countryNameTextStyle,
              ),
            ),
            Spacer(),
            Text(
              '${country.dialCode ?? ''}',
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.start,
              style: countryCodeTextStyle,
            ),
          ],
        ),
      ),
      // subtitle: Align(
      //   alignment: AlignmentDirectional.centerStart,
      //   child: Text(
      //     '${country.dialCode ?? ''}',
      //     textDirection: TextDirection.ltr,
      //     textAlign: TextAlign.start,
      //   ),
      // ),
      onTap: () => setCountry(country),
    );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? useEmoji;

  const _Flag({Key? key, this.country, this.useEmoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headline5,
                  )
                : country?.flagUri != null
                    // ? CircleAvatar(
                    //     backgroundImage: AssetImage(
                    //       country!.flagUri,
                    //       package: 'intl_phone_number_input',
                    //     ),
                    //   )
                    ? Image.asset(
                        country!.flagUri,
                        width: setCurrentWidth(41, context),
                        height: setCurrentHeight(24, context),
                        package: 'intl_phone_number_input',
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox.shrink();
                        },
                      )
                    : SizedBox.shrink(),
          )
        : SizedBox.shrink();
  }
}
