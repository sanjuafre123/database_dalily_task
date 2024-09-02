import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Utils/global.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Budget Tracker',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
        () => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.grey,
                      ),
                    ),
                    hintText: 'Search',
                  ),
                  onChanged: (value) {
                    controller.getRecordsBySearch(value);
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.getCategoryRecord(1);
                    },
                    child: Container(
                        height: 60,
                        width: 90,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Income',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${controller.totalIncome}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.getCategoryRecord(0);
                    },
                    child: Container(
                        height: 60,
                        width: 90,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Expense',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${controller.totalExpense}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.getRecords();
                    },
                    child: Container(
                      height: 60,
                      width: 90,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '${controller.totalIncome.value - controller.totalExpense.value}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: ListView.builder(
                    itemCount: controller.data.length,
                    itemBuilder: (context, index) => Card(
                      color: controller.data[index]['isIncome'] == 1
                          ? Colors.green[200]
                          : Colors.red[200],
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              FileImage(File(controller.data[index]['img'])),
                        ),
                        title:
                            Text(controller.data[index]['amount'].toString()),
                        subtitle: Text(controller.data[index]['category']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Update details'),
                                    content: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              ImagePicker imagePicker =
                                                  ImagePicker();
                                              controller.xFileImage.value =
                                                  (await imagePicker.pickImage(
                                                      source:
                                                          ImageSource.gallery));
                                              controller.pickImage();
                                            },
                                            child: Obx(
                                              () => CircleAvatar(
                                                radius: 30,
                                                backgroundImage: controller
                                                            .fileImage.value !=
                                                        null
                                                    ? FileImage(
                                                        File(controller
                                                            .fileImage
                                                            .value!
                                                            .path),
                                                      )
                                                    : null,
                                                child: controller
                                                            .fileImage.value ==
                                                        null
                                                    ? const Icon(
                                                        Icons.add_a_photo)
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          buildTextFormField(
                                            label: 'Amount',
                                            controller: controller.txtAmount,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          buildTextFormField(
                                            label: 'Category',
                                            controller: controller.txtCategory,
                                          ),
                                          Obx(
                                            () => SwitchListTile(
                                              activeTrackColor: Colors.green,
                                              title: const Text('Income'),
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
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          String img =
                                              controller.fileImage.value!.path;
                                          bool response =
                                              formKey.currentState!.validate();
                                          if (response) {
                                            controller.updateRecord(
                                              controller.data[index]['id'],
                                              double.parse(
                                                  controller.txtAmount.text),
                                              controller.isIncome.value ? 1 : 0,
                                              controller.txtCategory.text,
                                              img,
                                            );
                                          }
                                          controller.txtAmount.clear();
                                          controller.txtCategory.clear();
                                          controller.isIncome.value = false;
                                          controller.fileImage =
                                              Rx<File?>(null);
                                          Get.back();
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                controller
                                    .deleteRecord(controller.data[index]['id']);
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add details'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        controller.xFileImage.value = (await imagePicker
                            .pickImage(source: ImageSource.gallery));
                        controller.pickImage();
                      },
                      child: Obx(
                        () => CircleAvatar(
                          radius: 30,
                          backgroundImage: controller.fileImage.value != null
                              ? FileImage(
                                  File(controller.fileImage.value!.path),
                                )
                              : null,
                          child: controller.fileImage.value == null
                              ? const Icon(Icons.add_a_photo)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildTextFormField(
                      label: 'Amount',
                      controller: controller.txtAmount,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildTextFormField(
                      label: 'Category',
                      controller: controller.txtCategory,
                    ),
                    Obx(
                      () => SwitchListTile(
                        activeTrackColor: Colors.green,
                        title: const Text('Income'),
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
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    String img = controller.fileImage.value!.path;
                    bool response = formKey.currentState!.validate();
                    if (response) {
                      controller.initRecord(
                        double.parse(controller.txtAmount.text),
                        controller.isIncome.value ? 1 : 0,
                        controller.txtCategory.text,
                        img,
                      );
                    }
                    Get.back();
                    controller.txtAmount.clear();
                    controller.txtCategory.clear();
                    controller.isIncome.value = false;
                    controller.fileImage = Rx<File?>(null);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
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
        labelStyle: const TextStyle(color: Colors.grey),
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
    );
  }
}
