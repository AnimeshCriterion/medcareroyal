
class AllApi{
  static String generateOTPForPatient ='Patient/generateOTPForPatient';
  static String checkLogin ='Patient/checkLogin';
  static String patientDashboard = 'Patient/patientDasboard';
  static String getMenuForApp ='Patient/getMenuForApp';
  static String getAllDepartment ='Patient/getAllDepartment';
  static String  getHospitalListForHomeIsolation ='Patient/getHospitalListForHomeIsolation';
  static String supplementCheckList = "covidSupplementChecklist";
  static String updateMember = "Patient/updateMember";
  static String saveMultipleFile = "Doctor/saveMultipleFile";
  static String getDoctorProfileBySpeciality = "Patient/getDoctorProfileBySpeciality";
  static String patientRegistration = "Patient/patientRegistration";
  static String addMember = "Patient/addMember";
  static String getAppointmentSlot="Patient/getOnlineAppointmentSlotsByKIOSK";
  static String getAddVital="Patient/addVital";
  static String PatientAppointmentList="Patient/getPatientAppointmentList";
  static String PatientCancelAppointment="Patient/cancelAppointment";
  static String getPatientMedicationDetails="Patient/getPatientMedicationDetails";
  static String getpatientInvestigationDetails="Patient/getpatientInvestigationDetails";
  static String getAllTest="Patient/getAllTest";
  static String getAllUnit="Doctor/getAllUnit";
  static String savePatientInvestigation="Patient/patientInvestigation";
  static String PatientVitalList="Patient/getPatientVitalList";
  // static String getProblemsWithIcon="Patient/getProblemsWithIcon";
  static String getProblemsWithIcon="api/DigiDoctorApis/GetProblemsWithIcon";
  static String patientAllProblems="Patient/getAllProblems";
  static String patientOnlineAppointment="Patient/onlineAppointment";
  static String checkTimeSlotAvailability="Patient/checkTimeSlotAvailability";
  static String getPaymentMode="Pharmacy/getPaymentMode";
  static String getTransactionNumber="Patient/getTransactionNo";
  static String getPatientRegistration="Patient/patientRegistration";
  static String getPatientVitalsDateWiseHistory="Patient/getPatientVitalsDateWiseHistory";
  static String getHospitalClinicDetails="Patient/getHospitalClinicDetails";
  static String getSymptomByProblem="GetKioskSymptomsByProblemId";
  static String getDoctorBySymptoms="Patient/getDoctorProfileBySymptom";
  static String getMember="Patient/getMembers";
  static String deleteMember="Patient/deleteMember";
  static String getHomeIsolationRequest="Patient/homeIsolationRequest";
  static String homeIsolationRequestList="Patient/homeIsolationRequestList";
  static String getpatientMedication="Patient/patientMedication";
  // static String getAllSuggestedProblem="Patient/getAllSuggestedProblem";
  static String getAllSuggestedProblem="api/DigiDoctorApis/GetAllSuggestedProblem";
  static String getAttributeByProblem="Patient/getAttributeByProblem";
  static String getMedicineReminder="Patient/medicineReminderList";
  static String getTrendingDiseaseList="trendingDiseaseList";
  static String diseaseReportData="diseaseReportData";
  static String getMedicationDetailsForPDF="Patient/getMedicationDetailsForPDF";
  static String GetInvestigationBillFormedvantage_patient="Investigation/GetInvestigationBillFormedvantage_patient";
  static String viewBillDetailsmedvantage_patient="Investigation/ViewBillDetailsmedvantage_patient";
  static String getPatientSymptomNotification="Patient/getPatientSymptomNotification";
  static String addMemberProblem="Patient/addMemberProblem";
  static String updatePatientSymptomsNotification="Patient/updatePatientSymptomNotification";
  static String getRadioDateWiseInvestigationDetailsmedvantage_patient="InvestigationSubCategoryWise/GetRadioDateWiseInvestigationDetailsmedvantage_patient";
  static String getICUDailyChart="ICUDailyChart/GetPACSURL";
  static String getMicrobiologyInvestigation="InvestigationSubCategoryWise/GetMicrobiologyInvestigationsmedvantage_patient";
  static String microbiologySubCategoryInvestigation="InvestigationSubCategoryWise/GetMicrobiologySubCategoryWiseInvestigationsmedvantage_patient";
  static String getDoctorProfile="Doctor/getDoctorProfile";
  //Medcare Royal patient
  static String addVitalHM="HomeCareService/InsertHomeCareVitals?";
  // static String addSymptompsHm="api/HomeCareSymtoms/InsertHomeCareSymtoms?";
  static String addSymptompsHm="api/PatientIPDPrescription/InsertSymtoms?";
  static String addFoodIntake="api/FoodIntake/IntakeByDietID?";
  static String allActivityCronicleList="api/ActivitiesChronicle/getAllActivitiesChronicleList?";
  static String saveFeedBackData="api/HomeCareTasks/SaveFeedback";
  static String getAllStatus="api/StatusMaster/GetAllStatus?";
  static String getFaqList="api/HomeCareTasks/GetFAQList?";







}
