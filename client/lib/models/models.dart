class Users{
  late String? email;
  late String? uname;
  late String? phone;
  late String? uid;
  late String? address;
}
class Vehicle {
  late String userId;
  late String ownerName;
  late String vehicleId;
  late String make;
  late String model;
  late int makeYear;
  late String vehicleIdentificationNumber;
  late String licenceNumber;
  Vehicle(){}
  Vehicle.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ?? '';
    ownerName = json['owner_name'] ?? '';
    vehicleId = json['vehicle_id'] ?? '';
    make = json['make'] ?? '';
    model = json['model'] ?? '';
    makeYear = json['make_year'] ?? 0;
    vehicleIdentificationNumber = json['vehicle_identification_number'] ?? '';
    licenceNumber = json['licence_number'] ?? '';
  }
  String toString() {
    return 'Vehicle{userId: $userId, ownerName: $ownerName, vehicleId: $vehicleId, make: $make, model: $model, makeYear: $makeYear, vehicleIdentificationNumber: $vehicleIdentificationNumber, licenceNumber: $licenceNumber}';
  }
}


class RegistrationDocuments {
  late String registrationId;
  late String vehicleId;
  late String documentName;
  late String documentNumber;
  late DateTime expirationDate;
  RegistrationDocuments();

  RegistrationDocuments.fromJson(Map<String, dynamic> json) {
    registrationId = json['registration_id'] ?? "";
    vehicleId = json['vehicle_id'] ?? "";
    documentName = json['document_name'] ?? '';
    documentNumber = json['document_number'] ?? '';
    expirationDate = DateTime.parse(json['expiration_date'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'registration_id': registrationId,
      'vehicle_id': vehicleId,
      'document_name': documentName,
      'document_number': documentNumber,
      'expiration_date': expirationDate.toIso8601String(),
    };
  }
}

class InsuranceDocuments {
  late String insuranceId;
  late String vehicleId;
  late String policyNumber;
  late DateTime expireDate;
  late String fileDocumentPath;
  late String docsStatus;
  late DateTime uploadDate;

  InsuranceDocuments.fromJson(Map<String, dynamic> json) {
    insuranceId = json['insurance_id'] ?? '';
    vehicleId = json['vehicle_id'] ?? '';
    policyNumber = json['policy_number'] ?? '';
    expireDate =
    json['expire_date'] != null ? DateTime.parse(json['expire_date']) : DateTime
        .now();
    fileDocumentPath = json['file_document_path'] ?? '';
    docsStatus = json['docs_status'] ?? '';
    uploadDate =
    json['upload_date'] != null ? DateTime.parse(json['upload_date']) : DateTime
        .now();
  }

  Map<String, dynamic> toJson() {
    return {
      'insurance_id': insuranceId,
      'vehicle_id': vehicleId.toString(),
      'policy_number': policyNumber,
      'expire_date': expireDate.toIso8601String(),
      'file_document_path': fileDocumentPath,
      'docs_status': docsStatus,
      'upload_date': uploadDate.toIso8601String(),
    };
  }
}
class InspectionDocuments {
  late String inspectionId;
  late String vehicleId;
  late String certificateNumber;
  late DateTime expirationDate;
  late String inspectionStation;
  InspectionDocuments();

  InspectionDocuments.fromJson(Map<String, dynamic> json) {
    inspectionId = json['inspection_id'] ?? "";
    vehicleId = json['vehicle_id'] ?? "";
    certificateNumber = json['certificate_number'] ?? '';
    expirationDate = DateTime.parse(json['expiration_date'] ?? '');
    inspectionStation = json['inspection_station'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'inspection_id': inspectionId,
      'vehicle_id': vehicleId,
      'certificate_number': certificateNumber,
      'expiration_date': expirationDate.toIso8601String(),
      'inspection_station': inspectionStation,
    };
  }
}

class EmissionDocuments {
  late String emissionId;
  late String vehicleId;
  late String certificateNumber;
  late DateTime issueDate;
  late DateTime expirationDate;
  EmissionDocuments();

  EmissionDocuments.fromJson(Map<String, dynamic> json) {
    emissionId = json['emission_id'] ?? "";
    vehicleId = json['vehicle_id'] ?? "";
    certificateNumber = json['certificate_number'] ?? '';
    issueDate = DateTime.parse(json['issue_date'] ?? '');
    expirationDate = DateTime.parse(json['expiration_date'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'emission_id': emissionId,
      'vehicle_id': vehicleId,
      'certificate_number': certificateNumber,
      'issue_date': issueDate.toIso8601String(),
      'expiration_date': expirationDate.toIso8601String(),
    };
  }
}

class ComplaintRegistration {
  late String vehicleId;
  late String complaint;
  late DateTime complaintDate;
  late String fileDocumentPath;
  late DateTime uploadDate;
  late String fileType;
  late int fileSize;
  late bool resolved;
  ComplaintRegistration();

  ComplaintRegistration.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'] ?? "";
    complaint = json['complaint'] ?? '';
    complaintDate = DateTime.parse(json['complaint_date'] ?? '');
    fileDocumentPath = json['file_document_path'] ?? '';
    uploadDate = DateTime.parse(json['upload_date'] ?? '');
    fileType = json['file_type'] ?? '';
    fileSize = json['file_size'] ?? 0;
    resolved = json['resolved'] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'complaint': complaint,
      'complaint_date': complaintDate.toIso8601String(),
      'file_document_path': fileDocumentPath,
      'upload_date': uploadDate.toIso8601String(),
      'file_type': fileType,
      'file_size': fileSize,
      'resolved': resolved,
    };
  }
}

