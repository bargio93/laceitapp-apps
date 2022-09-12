
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
class Permissions{
  static var permissions = [
    Permission.location,
  ];
  static String checkServiceStatus(BuildContext context){
    var status = "Failed";
    permissions.forEach((perm) async {
      perm.serviceStatus.then((value) => check_permission(value));
    });


    return status;

  }

  static void check_permission(value){
    print("IL VOLRE è" + value.toString());
    if (value == ServiceStatus.enabled){
      requestPermission(Permission.location);
    }

  }

  static Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status;
  }
}