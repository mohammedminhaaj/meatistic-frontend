import 'package:flutter/material.dart';
import 'package:meatistic/widgets/modal_header.dart';

class DeliveryInstructions extends StatefulWidget {
  const DeliveryInstructions({super.key, this.instructions});
  final String? instructions;
  @override
  State<StatefulWidget> createState() => _DeliveryInstructionsState();
}

class _DeliveryInstructionsState extends State<DeliveryInstructions> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.instructions ?? "";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const ModalHeader(headerText: "Delivery Instructions"),
        const SizedBox(
          height: 10,
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _controller,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                maxLength: 150,
                maxLines: 4,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    hintText: "Type your instructions here..."),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    color: Colors.red[100]),
                padding: const EdgeInsets.all(15),
                child: const Text(
                    "The vendor will try their best to follow your instructions. However, no cancellation or refund will be possible if your request is not met."),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                          _controller.text.isEmpty ? null : _controller.text);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white),
                    child: const Text("Save"),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        )
      ]),
    );
  }
}
