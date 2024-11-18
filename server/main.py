from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
import uuid
import bcrypt
from sqlalchemy.orm.exc import NoResultFound
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
# MySQL Configuration choose your port no and password this is a dummy thing i have set up
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqlconnector://root:user@127.0.0.1:3307/vechiledbms'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)


# Example Model
class Users(db.Model):
    __tablename__ = 'users'
    user_id = db.Column(db.String(36), primary_key=True)
    user_name = db.Column(db.String(50))
    email = db.Column(db.String(50), unique=True)
    phone_no = db.Column(db.String(14))
    address = db.Column(db.String(60))
    userpass = db.Column(db.String(255))


class Vehicle(db.Model):
    __tablename__ = 'vehicle'
    user_id = db.Column(db.String(36), db.ForeignKey('users.user_id'), nullable=False)
    owner_name = db.Column(db.String(50))
    vehicle_id = db.Column(db.String(36), primary_key=True, unique=True, nullable=False)
    make = db.Column(db.String(60))
    model = db.Column(db.String(60))
    make_year = db.Column(db.Integer)
    vehicle_identification_number = db.Column(db.String(10))
    licence_number = db.Column(db.String(20))
    user = db.relationship('Users', backref='vehicle', lazy=True)


class RegistrationDocuments(db.Model):
    __tablename__ = 'registration_documents'
    registration_id = db.Column(db.String(36), primary_key=True, nullable=False)
    vehicle_id = db.Column(db.String(36), db.ForeignKey('vehicle.vehicle_id'), nullable=False)
    document_name = db.Column(db.String(50))
    document_number = db.Column(db.String(20), unique=True)
    expiration_date = db.Column(db.Date)
    vehicle = db.relationship('Vehicle', backref='registration_documents', lazy=True)


class InsuranceDocuments(db.Model):
    __tablename__ = 'insurance_documents'
    insurance_id = db.Column(db.String(36), primary_key=True, nullable=False)
    vehicle_id = db.Column(db.String(36), db.ForeignKey('vehicle.vehicle_id'), nullable=False)
    policy_number = db.Column(db.String(40))
    expire_date = db.Column(db.Date)
    file_document_path = db.Column(db.String(255))
    docs_status = db.Column(db.String(20))
    upload_date = db.Column(db.Date)
    vehicle = db.relationship('Vehicle', backref='insurance_documents', lazy=True)


class InspectionDocuments(db.Model):
    __tablename__ = 'inspection_documents'
    inspection_id = db.Column(db.String(36), primary_key=True, nullable=False)
    vehicle_id = db.Column(db.String(36), db.ForeignKey('vehicle.vehicle_id'), nullable=False)
    certificate_number = db.Column(db.String(30))
    expiration_date = db.Column(db.Date)
    inspection_station = db.Column(db.String(100))
    vehicle = db.relationship('Vehicle', backref='inspection_documents', lazy=True)


class EmissionDocuments(db.Model):
    __tablename__ = 'emission_documents'
    emission_id = db.Column(db.String(36), primary_key=True, nullable=False)
    vehicle_id = db.Column(db.String(36), db.ForeignKey('vehicle.vehicle_id'), nullable=False)
    certificate_number = db.Column(db.String(30))
    issue_date = db.Column(db.Date)
    expiration_date = db.Column(db.Date)
    vehicle = db.relationship('Vehicle', backref='emission_documents', lazy=True)


class ComplaintRegistration(db.Model):
    __tablename__ = 'complaint_registration'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    vehicle_id = db.Column(db.String(36), db.ForeignKey('vehicle.vehicle_id'), nullable=False)
    complaint = db.Column(db.String(500), nullable=False)
    complaint_date = db.Column(db.DateTime)
    file_document_path = db.Column(db.String(255))
    upload_date = db.Column(db.Date)
    file_type = db.Column(db.String(10))
    file_size = db.Column(db.Integer)
    resolved = db.Column(db.Boolean)
    vehicle = db.relationship('Vehicle', backref='complaints', lazy=True)


# Home route brute force search used
@app.route('/users/signup', methods=['GET', 'POST'])
def get_all_users():
    if request.method == 'GET':
        users = Users.query.all()
        user_list = []
        for user in users:
            user_data = {
                'user_id': user.user_id,
                'user_name': user.user_name,
                'email': user.email,
                'phone_no': user.phone_no,
                'address': user.address
            }
            user_list.append(user_data)
        return jsonify({'users': user_list})
    if request.method == 'POST':
        data = request.get_json(force=True)
        user_id = data["user_id"]
        user_email = data["email"]
        # user_name=data["user_name"]
        userpass = data["userpass"]
        users = Users.query.all()
        user_list = []
        for user in users:
            if user.email == user_email:
                return jsonify({"msg": "This user already exits Login"}), 401
        if user_id != "":
            return jsonify({"msg": "Logout the user and retry"}), 402
        u = Users()
        u.user_id = str(uuid.uuid4())
        u.email = user_email
        u.user_name = ""
        u.phone_no = ""
        u.address = ""
        bytes = userpass.encode('utf-8')
        salt = bcrypt.gensalt()
        hash = bcrypt.hashpw(bytes, salt)
        u.userpass = hash
        db.session.add(u)
        db.session.commit()
        return jsonify({"msg": "User created successfully"}), 201


# POST route to signup user
@app.route('/users/signin', methods=['POST'])
def add_user():
    data = request.get_json(force=True)

    # Check if the user already exists
    existing_user = Users.query.filter_by(email=data['email']).first()

    if existing_user:
        # User already exists, check password
        bytes_password = data['userpass'].encode('utf-8')
        hashed_password = bcrypt.hashpw(bytes_password, existing_user.userpass.encode('utf-8'))

        if bcrypt.checkpw(data['userpass'].encode('utf-8'), existing_user.userpass.encode('utf-8')):
            return jsonify({'msg': 'Password matched', 'uid': existing_user.user_id}), 201
        else:
            return jsonify({'msg': 'User signed up but passwords do not match'}), 401
    else:
        return jsonify({'msg': 'user does not existss'}), 403


# GET route to fetch all vehicles of the user
@app.route('/vehicles/<user_id>', methods=['GET'])
def get_all_vehicles(user_id):
    vehicles = Vehicle.query.all()
    vehicle_list = []
    for vehicle in vehicles:
        if user_id == vehicle.user_id:
            vehicle_data = {
                'user_id': vehicle.user_id,
                'owner_name': vehicle.owner_name,
                'vehicle_id': vehicle.vehicle_id,
                'make': vehicle.make,
                'model': vehicle.model,
                'make_year': vehicle.make_year,
                'vehicle_identification_number': vehicle.vehicle_identification_number,
                'licence_number': vehicle.licence_number
            }
            vehicle_list.append(vehicle_data)
    return jsonify({'vehicles': vehicle_list})


# Get Route to fetch all vehicles in the database
@app.route('/vehicles/all', methods=['GET'])
def vehicles():
    vehicles = Vehicle.query.all()
    vehicle_list = []
    for vehicle in vehicles:
        vehicle_data = {
            'user_id': vehicle.user_id,
            'owner_name': vehicle.owner_name,
            'vehicle_id': vehicle.vehicle_id,
            'make': vehicle.make,
            'model': vehicle.model,
            'make_year': vehicle.make_year,
            'vehicle_identification_number': vehicle.vehicle_identification_number,
            'licence_number': vehicle.licence_number
        }
        vehicle_list.append(vehicle_data)
    return jsonify({'vehicles': vehicle_list})


# POST route to add a new vehicle
@app.route('/vehicles', methods=['POST'])
def add_vehicle():
    data = request.get_json(force=True)
    new_vehicle = Vehicle(
        user_id=data['user_id'],
        owner_name=data['owner_name'],
        vehicle_id=data['vehicle_id'],
        make=data['make'],
        model=data['model'],
        make_year=data['make_year'],
        vehicle_identification_number=data['vehicle_identification_number'],
        licence_number=data['licence_number']
    )
    db.session.add(new_vehicle)
    db.session.commit()
    return jsonify({'message': 'Vehicle added successfully'}), 201


# POST route to register a document
@app.route('/documents/register', methods=['POST'])
def register_document():
    data = request.get_json(force=True)
    new_document = RegistrationDocuments(
        registration_id=str(uuid.uuid4()),
        vehicle_id=data['vehicle_id'],
        document_name=data['document_name'],
        document_number=data['document_number'],
        expiration_date=data['expiration_date']
    )
    db.session.add(new_document)
    db.session.commit()
    return jsonify({'message': 'Document registered successfully'}), 201


# POST route to register a complaint
@app.route('/complaints/register', methods=['POST'])
def register_complaint():
    data = request.get_json(force=True)
    new_complaint = ComplaintRegistration(

        vehicle_id=data['vehicle_id'],
        complaint=data['complaint'],
        complaint_date=data['complaint_date'],
        file_document_path=data['file_document_path'],
        upload_date=data['upload_date'],
        file_type=data['file_type'],
        file_size=data['file_size'],
        resolved=data['resolved']
    )
    db.session.add(new_complaint)
    db.session.commit()
    return jsonify({'message': 'Complaint registered successfully'}), 201


# POST route to add insurance information
@app.route('/insurance/register', methods=['POST'])
def register_insurance():
    data = request.get_json(force=True)
    new_insurance = InsuranceDocuments(
        insurance_id=data['insurance_id'],
        vehicle_id=data['vehicle_id'],
        policy_number=data['policy_number'],
        expire_date=data['expire_date'],
        file_document_path=data['file_document_path'],
        docs_status=data['docs_status'],
        upload_date=data['upload_date']
    )
    db.session.add(new_insurance)
    db.session.commit()
    return jsonify({'message': 'Insurance information added successfully'}), 201


# POST route to add emission information
@app.route('/emission/register', methods=['POST'])
def register_emission():
    data = request.get_json(force=True)
    new_emission = EmissionDocuments(
        vehicle_id=data['vehicle_id'],
        certificate_number=data['certificate_number'],
        issue_date=data['issue_date'],
        expiration_date=data['expiration_date'],
        emission_id=str(uuid.uuid4()),
    )
    db.session.add(new_emission)
    db.session.commit()
    return jsonify({'message': 'Emission information added successfully'}), 201


# get routes
# GET route to fetch insurance documents for a specific vehicle
@app.route('/insurance/<string:user_id>/<string:vehicle_id>', methods=['GET'])
def get_insurance_documents(user_id, vehicle_id):
    try:
        vehicle = Vehicle.query.filter_by(vehicle_id=vehicle_id, user_id=user_id).one()
    except NoResultFound:
        return jsonify({'msg': 'Vehicle not found'}), 404

    insurance_documents = InsuranceDocuments.query.filter_by(vehicle_id=vehicle_id).all()

    if not insurance_documents:
        return jsonify({'msg': 'No insurance documents found for the vehicle'}), 404

    insurance_list = []
    for document in insurance_documents:
        document_data = {
            'vehicle_id':document.vehicle_id,
            'insurance_id': document.insurance_id,
            'policy_number': document.policy_number,
            'expire_date': document.expire_date.strftime('%Y-%m-%d'),
            'file_document_path': document.file_document_path,
            'docs_status': document.docs_status,
            'upload_date': document.upload_date.strftime('%Y-%m-%d')
        }
        insurance_list.append(document_data)

    return jsonify({'insurance_documents': insurance_list}), 201


# GET route to fetch emission documents for a specific vehicle
@app.route('/emission/<string:user_id>/<string:vehicle_id>', methods=['GET'])
def get_emission_documents(user_id, vehicle_id):
    try:
        vehicle = Vehicle.query.filter_by(vehicle_id=vehicle_id, user_id=user_id).one()
    except NoResultFound:
        return jsonify({'msg': 'Vehicle not found'}), 404

    emission_documents = EmissionDocuments.query.filter_by(vehicle_id=vehicle_id).all()

    if not emission_documents:
        return jsonify({'msg': 'No emission documents found for the vehicle'}), 404

    emission_list = []
    for document in emission_documents:
        document_data = {
            'vehicle_id': document.vehicle_id,
            'emission_id': document.emission_id,
            'certificate_number': document.certificate_number,
            'issue_date': document.issue_date.strftime('%Y-%m-%d'),
            'expiration_date': document.expiration_date.strftime('%Y-%m-%d')
        }
        emission_list.append(document_data)

    return jsonify({'emission_documents': emission_list}), 201


@app.route('/registration/<string:user_id>/<string:vehicle_id>', methods=['GET'])
def get_registration_documents(user_id, vehicle_id):
    try:
        vehicle = Vehicle.query.filter_by(vehicle_id=vehicle_id, user_id=user_id).one()
    except NoResultFound:
        return jsonify({'msg': 'Vehicle not found'}), 404

    registration_documents = RegistrationDocuments.query.filter_by(vehicle_id=vehicle_id).all()

    if not registration_documents:
        return jsonify({'msg': 'No registration documents found for the vehicle'}), 404

    registration_list = []
    for document in registration_documents:
        document_data = {
            'vehicle_id':document.vehicle_id,
            'registration_id': document.registration_id,
            'document_name': document.document_name,
            'document_number': document.document_number,
            'expiration_date': document.expiration_date.strftime('%Y-%m-%d')
        }
        registration_list.append(document_data)

    return jsonify({'registration_documents': registration_list}), 201


@app.route('/get_resolved_complaints/<vehicle_id>', methods=['GET'])
def get_resolved_complaints(vehicle_id):
    try:
        complaints = ComplaintRegistration.query.filter_by(vehicle_id=vehicle_id, resolved=True).all()
        result = []
        for complaint in complaints:
            result.append({
                'complaint': complaint.complaint,
                'complaint_date': complaint.complaint_date.strftime('%Y-%m-%d %H:%M:%S'),
                'file_document_path': complaint.file_document_path,
                'upload_date': complaint.upload_date.strftime('%Y-%m-%d'),
                'file_type': complaint.file_type,
                'file_size': complaint.file_size,
                'resolved': complaint.resolved
            })
        if result==[]:
            return jsonify({'msg':"no active complaints"}),404

        return jsonify({'complaints': result}), 201
    except Exception as e:
        return jsonify({'error': str(e)})


# delete routes
# Delete Route for Vehicle
@app.route('/vehicles/delete/<string:vehicle_id>', methods=['DELETE'])
def delete_vehicle(vehicle_id):
    try:
        # Check if the vehicle for the specified vehicle_id exists
        vehicle = Vehicle.query.filter_by(vehicle_id=vehicle_id).first()

        if vehicle is None:
            return jsonify({'error': 'Vehicle not found'}), 404

        # Delete the vehicle
        db.session.delete(vehicle)
        db.session.commit()

        return jsonify({'message': 'Vehicle deleted successfully'}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


# Delete Route for Registration Documents
@app.route('/registration/delete/<vehicle_id>', methods=['DELETE'])
def delete_registration(vehicle_id):
    try:
        # Check if the registration document for the specified vehicle_id exists
        registration = RegistrationDocuments.query.filter_by(vehicle_id=vehicle_id).first()

        if registration is None:
            return jsonify({'error': 'Registration document not found'}), 404

        # Delete the registration document
        db.session.delete(registration)
        db.session.commit()

        return jsonify({'message': 'Registration document deleted successfully'}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


# Delete Route for Insurance Documents
@app.route('/insurance/delete/<vehicle_id>', methods=['DELETE'])
def delete_insurance(vehicle_id):
    try:
        # Check if the insurance document for the specified vehicle_id exists
        insurance = InsuranceDocuments.query.filter_by(vehicle_id=vehicle_id).first()

        if insurance is None:
            return jsonify({'error': 'Insurance document not found'}), 404

        # Delete the insurance document
        db.session.delete(insurance)
        db.session.commit()

        return jsonify({'message': 'Insurance document deleted successfully'}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


# Delete Route for Emission Documents
@app.route('/emission/delete/<vehicle_id>', methods=['DELETE'])
def delete_emission(vehicle_id):
    try:
        # Check if the emission document for the specified vehicle_id exists
        emission = EmissionDocuments.query.filter_by(vehicle_id=vehicle_id).first()

        if emission is None:
            return jsonify({'error': 'Emission document not found'}), 404

        # Delete the emission document
        db.session.delete(emission)
        db.session.commit()

        return jsonify({'message': 'Emission document deleted successfully'}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


# Update routes
@app.route('/vehicles/update/<vehicle_id>', methods=['PUT'])
def update_vehicle(vehicle_id):
    try:
        # Check if the vehicle for the specified vehicle_id exists
        vehicle = Vehicle.query.filter_by(vehicle_id=vehicle_id).first()

        if vehicle is None:
            return jsonify({'error': 'Vehicle not found'}), 404

        # Update the vehicle details based on the request data
        data = request.get_json(force=True)
        vehicle.owner_name = data.get('owner_name', vehicle.owner_name)
        vehicle.vehicle_identification_number = data.get('vehicle_identification_number', vehicle.vehicle_identification_number)
        vehicle.model = data.get('model', vehicle.model)
        vehicle.licence_number= data.get('licence_number', vehicle.licence_number)

        db.session.commit()

        return jsonify({'message': 'Vehicle details updated successfully'}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@app.route('/registration/update/<vehicle_id>', methods=['PUT'])
def update_registration(vehicle_id):
    try:
        # Check if the registration document for the specified vehicle_id exists
        registration = RegistrationDocuments.query.filter_by(vehicle_id=vehicle_id).first()

        if registration is None:
            return jsonify({'error': 'Registration document not found'}), 404

        # Update the registration document details based on the request data
        data = request.get_json(force=True)
        registration.document_name = data.get('document_name', registration.document_name)
        registration.document_number = data.get('document_number', registration.document_number)
        registration.expiration_date = data.get('expiration_date', registration.expiration_date)

        db.session.commit()

        return jsonify({'message': 'Registration document updated successfully'}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@app.route('/insurance/update/<vehicle_id>', methods=['PUT'])
def update_insurance(vehicle_id):
    try:
        # Check if the insurance document for the specified vehicle_id exists
        insurance = InsuranceDocuments.query.filter_by(vehicle_id=vehicle_id).first()

        if insurance is None:
            return jsonify({'error': 'Insurance document not found'}), 404

        # Update the insurance document details based on the request data
        data = request.get_json(force=True)
        insurance.policy_number = data.get('policy_number', insurance.policy_number)
        insurance.expire_date = data.get('expire_date', insurance.expire_date)
        insurance.file_document_path = data.get('file_document_path', insurance.file_document_path)
        insurance.docs_status = data.get('docs_status', insurance.docs_status)
        insurance.upload_date = data.get('upload_date', insurance.upload_date)

        db.session.commit()

        return jsonify({'message': 'Insurance document updated successfully'}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@app.route('/emission/update/<vehicle_id>', methods=['PUT'])
def update_emission(vehicle_id):
    try:
        # Check if the emission document for the specified vehicle_id exists
        emission = EmissionDocuments.query.filter_by(vehicle_id=vehicle_id).first()

        if emission is None:
            return jsonify({'error': 'Emission document not found'}), 404

        # Update the emission document details based on the request data
        data = request.get_json(force=True)
        emission.certificate_number = data.get('certificate_number', emission.certificate_number)
        emission.issue_date = data.get('issue_date', emission.issue_date)
        emission.expiration_date = data.get('expiration_date', emission.expiration_date)

        db.session.commit()

        return jsonify({'message': 'Emission document updated successfully'}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


# admin routes
@app.route('/admin/control', methods=['GET'])
def fun1():
    return "Yes admin route touched you can handle the admin logic here"


if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True, host='0.0.0.0', port=3300)
