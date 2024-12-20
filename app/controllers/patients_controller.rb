class PatientsController < ApplicationController
  before_action :set_patient, only: [ :edit, :update, :destroy ]

  def index
    @patients = current_user.patients
                  .order(created_at: :desc)
                  .then { |patients| params[:query].present? ? patients.search(params[:query]) : patients }
                  .page(params[:page])
  end

  def upcoming
    @patients = current_user.patients.upcoming_appointments.page(params[:page]).per(10)
    render :index
  end

  def new
    @patient = current_user.patients.build
  end

  def create
    @patient = current_user.patients.new(patient_params)
    if @patient.save
      redirect_to patients_path, notice: "Patient was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @patient.update(patient_params)
      redirect_to patients_path, notice: "Patient was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy
  end

  private

  def set_patient
    @patient = current_user.patients.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :email, :next_appointment_date)
  end
end
