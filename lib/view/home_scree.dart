import 'package:database_daily_task/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Budget Tracker',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Handle menu action
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: Obx(
            () => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    controller.totalIncome != 0.0.obs
                        ? 'Total Income: ${controller.totalIncome}'
                        : '',
                    style: const TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    controller.totalExpense != 0.0.obs
                        ? 'Total Expense: ${controller.totalExpense}'
                        : '',
                    style: const TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.data.length,
                itemBuilder: (context, index) => Card(
                  color: controller.data[index]['isIncome'] == 1
                      ? Colors.green[100]
                      : Colors.red[100],
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    title: Text(
                      controller.data[index]['amount'].toString(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      controller.data[index]['category'],
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black54),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _showUpdateDialog(context, index);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueGrey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.deleteRecord(controller.data[index]['id']);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Update details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextFormField(
                label: 'Amount',
                controller: controller.txtAmount,
              ),
              const SizedBox(height: 10),
              buildTextFormField(
                label: 'Category',
                controller: controller.txtCategory,
              ),
              Obx(
                    () => SwitchListTile(
                  activeTrackColor: Colors.green,
                  title: const Text('Income', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  value: controller.isIncome.value,
                  onChanged: (value) {
                    controller.setIsIncome(value);
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              bool response = formKey.currentState!.validate();
              if (response) {
                controller.updateRecord(
                  controller.data[index]['id'],
                  double.parse(controller.txtAmount.text),
                  controller.isIncome.value ? 1 : 0,
                  controller.txtCategory.text,
                );
              }
              Get.back();
              controller.txtAmount.clear();
              controller.txtCategory.clear();
              controller.isIncome.value = false;
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextFormField(
                label: 'Amount',
                controller: controller.txtAmount,
              ),
              const SizedBox(height: 10),
              buildTextFormField(
                label: 'Category',
                controller: controller.txtCategory,
              ),
              Obx(
                    () => SwitchListTile(
                  activeTrackColor: Colors.green,
                  title: const Text('Income', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  value: controller.isIncome.value,
                  onChanged: (value) {
                    controller.setIsIncome(value);
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              bool response = formKey.currentState!.validate();
              if (response) {
                controller.initRecord(
                  double.parse(controller.txtAmount.text),
                  controller.isIncome.value ? 1 : 0,
                  controller.txtCategory.text,
                );
              }
              Get.back();
              controller.txtAmount.clear();
              controller.txtCategory.clear();
              controller.isIncome.value = false;
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildTextFormField({
    required String label,
    required var controller,
  }) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        } else {
          return null;
        }
      },
      cursorColor: Colors.grey,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.grey,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    );
  }
}

var controller = Get.put(DataBaseController());
GlobalKey<FormState> formKey = GlobalKey();
