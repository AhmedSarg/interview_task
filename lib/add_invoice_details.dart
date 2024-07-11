import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:interview/database_controller.dart';
import 'package:sqflite/sqflite.dart';

class AddInvoiceDetails extends StatefulWidget {
  const AddInvoiceDetails({super.key});

  static final TextEditingController _productNameController =
      TextEditingController();
  static final TextEditingController _priceController = TextEditingController();
  static final TextEditingController _quantityController =
      TextEditingController();
  static final TextEditingController _totalController = TextEditingController();
  static final FocusNode _productNameFocusNode = FocusNode();
  static final FocusNode _priceFocusNode = FocusNode();
  static final FocusNode _quantityFocusNode = FocusNode();
  static final FocusNode _totalFocusNode = FocusNode();

  @override
  State<AddInvoiceDetails> createState() => _AddInvoiceDetailsState();
}

class _AddInvoiceDetailsState extends State<AddInvoiceDetails> {
  int? _unitNumber;
  DateTime? _expiryDate;
  late Database _database;

  void getData() async {
    DatabaseHelper.instance.database.then(
      (value) {
        _database = value!;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice Details Page"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DetailSection(
                title: 'Product Name',
                child: DetailTextField(
                  controller: AddInvoiceDetails._productNameController,
                  focusNode: AddInvoiceDetails._productNameFocusNode,
                ),
              ),
              const SizedBox(height: 20),
              DetailSection(
                title: 'Unit No.',
                child: UnitNumberSection(
                  selectedValue: _unitNumber,
                  onChanged: (int? value) {
                    setState(() {
                      _unitNumber = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              DetailSection(
                title: 'Price',
                child: DetailTextField(
                  controller: AddInvoiceDetails._priceController,
                  focusNode: AddInvoiceDetails._priceFocusNode,
                  nextFocusNode: AddInvoiceDetails._quantityFocusNode,
                  textInputType: TextInputType.number,
                  onChanged: (v) {
                    if (AddInvoiceDetails._priceController.text.isNotEmpty &&
                        AddInvoiceDetails._quantityController.text.isNotEmpty) {
                      AddInvoiceDetails._totalController.text = (int.parse(
                                  AddInvoiceDetails._priceController.text) *
                              int.parse(
                                  AddInvoiceDetails._quantityController.text))
                          .toString();
                    } else {
                      AddInvoiceDetails._totalController.clear();
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              DetailSection(
                title: 'Quantity',
                child: DetailTextField(
                  controller: AddInvoiceDetails._quantityController,
                  focusNode: AddInvoiceDetails._quantityFocusNode,
                  nextFocusNode: AddInvoiceDetails._totalFocusNode,
                  textInputType: TextInputType.number,
                  onChanged: (v) {
                    if (AddInvoiceDetails._priceController.text.isNotEmpty &&
                        AddInvoiceDetails._quantityController.text.isNotEmpty) {
                      AddInvoiceDetails._totalController.text = (int.parse(
                                  AddInvoiceDetails._priceController.text) *
                              int.parse(
                                  AddInvoiceDetails._quantityController.text))
                          .toString();
                    } else {
                      AddInvoiceDetails._totalController.clear();
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              DetailSection(
                title: 'Total',
                child: DetailTextField(
                  controller: AddInvoiceDetails._totalController,
                  focusNode: AddInvoiceDetails._totalFocusNode,
                  enabled: false,
                ),
              ),
              const SizedBox(height: 20),
              DetailSection(
                title: 'Expiry Date',
                child: DateSection(
                  value: _expiryDate,
                  onSelect: (value) {
                    setState(() {
                      _expiryDate = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ActionsRow(
                onNew: () {
                  AddInvoiceDetails._productNameController.clear();
                  AddInvoiceDetails._priceController.clear();
                  AddInvoiceDetails._quantityController.clear();
                  AddInvoiceDetails._totalController.clear();
                  setState(() {
                    _unitNumber = null;
                    _expiryDate = null;
                  });
                },
                onSave: () async {
                  await _database.insert(
                    DatabaseHelper.table,
                    {
                      DatabaseHelper.columnProductName:
                          AddInvoiceDetails._productNameController.text,
                      DatabaseHelper.columnUnitNumber: _unitNumber,
                      DatabaseHelper.columnPrice:
                          int.parse(AddInvoiceDetails._priceController.text),
                      DatabaseHelper.columnQuantity:
                          int.parse(AddInvoiceDetails._quantityController.text),
                      DatabaseHelper.columnTotal:
                          int.parse(AddInvoiceDetails._totalController.text),
                      DatabaseHelper.columnExpiryDate:
                          DateFormat('yyyy-MM-dd').format(_expiryDate!),
                    },
                  );
                  print(await _database.query(DatabaseHelper.table));
                },
                onDelete: () async {
                  await _database.delete(
                    DatabaseHelper.table,
                    where:
                        '${DatabaseHelper.columnProductName} = "${AddInvoiceDetails._productNameController.text}"',
                  );
                  print(await _database.query(DatabaseHelper.table));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailSection extends StatelessWidget {
  const DetailSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 20),
        child,
      ],
    );
  }
}

class DetailTextField extends StatelessWidget {
  const DetailTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.textInputType = TextInputType.text,
    this.enabled = true,
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final TextInputType textInputType;
  final bool enabled;
  final Function(String?)? onChanged;

  static const OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: TextField(
        controller: controller,
        keyboardType: textInputType,
        focusNode: focusNode,
        enabled: enabled,
        onEditingComplete: () {
          focusNode.unfocus();
          if (nextFocusNode != null) {
            nextFocusNode!.requestFocus();
          }
        },
        onChanged: onChanged,
        decoration: InputDecoration(
          enabledBorder: border,
          focusedBorder: border,
          disabledBorder: border,
          filled: !enabled,
          fillColor: Colors.grey,
        ),
      ),
    );
  }
}

class UnitNumberSection extends StatelessWidget {
  const UnitNumberSection({
    super.key,
    required this.onChanged,
    required this.selectedValue,
  });

  final int? selectedValue;
  final Function(int?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        height: 50,
        child: DropdownButton(
          value: selectedValue,
          items: [1, 2, 3, 4]
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.toString()),
                ),
              )
              .toList(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          underline: const SizedBox.shrink(),
          isExpanded: true,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class DateSection extends StatelessWidget {
  const DateSection({
    super.key,
    this.value,
    required this.onSelect,
  });

  final DateTime? value;
  final Function(DateTime?) onSelect;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: SizedBox(
        height: 50,
        child: TextButton(
          onPressed: () {
            showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(
                const Duration(days: 3650),
              ),
            ).then(onSelect);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(color: Colors.black),
            ),
          ),
          child: Text(
            value != null ? DateFormat('yyyy-MM-dd').format(value!) : '',
          ),
        ),
      ),
    );
  }
}

class ActionsRow extends StatelessWidget {
  const ActionsRow({
    super.key,
    required this.onNew,
    required this.onSave,
    required this.onDelete,
  });

  final Function() onNew;
  final Function() onSave;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: [
          Action(
            title: 'New',
            onPressed: onNew,
          ),
          const SizedBox(width: 10),
          Action(
            title: 'Save',
            onPressed: onSave,
          ),
          const SizedBox(width: 10),
          Action(
            title: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 10),
          Action(
            title: 'Delete',
            onPressed: onDelete,
            different: true,
          ),
        ],
      ),
    );
  }
}

class Action extends StatelessWidget {
  const Action({
    super.key,
    required this.title,
    required this.onPressed,
    this.different = false,
  });

  final String title;
  final Function() onPressed;
  final bool different;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: different ? Colors.red : Colors.blue,
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
