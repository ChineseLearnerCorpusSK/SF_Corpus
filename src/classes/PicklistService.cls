public class PicklistService {

	private static final String CLASS_NAME = 'PicklistService';

	/**
	 * Retrieves list of picklist items based on Object API Name and Field API Name.
	 * Values in list are wrapped inside PicklistItem wrapper.
	 * @param  objectName which contains desired picklist field
	 * @param  fieldName  for which you want to get picklist options
	 * @return            List of picklist options
	 */
	@AuraEnabled
	public static List<PicklistItem> getPicklist(String objectName, String fieldName) {
		System.debug(CLASS_NAME + '-> : objectName: ' + objectName);
		System.debug(CLASS_NAME + '-> : fieldName: ' + fieldName);
		List<SelectOption> options =  getPicklistValues(objectName, fieldName);
		List<PicklistItem> picklist = new List<PicklistItem>();
		if(options != null) {
			for (SelectOption option : options) {
				picklist.add(new PicklistItem(option));
			}
		}

		System.debug(CLASS_NAME + '-> List<PicklistItem>: ' + picklist);
		return picklist;
	}

	public static List<SelectOption> getPicklistValues(String objName, String fieldName) {
		if(String.isBlank(objName) || String.isBlank(fieldName)) {
			return null;
		}

		List<SelectOption> options = null;
		SObjectType obj = Schema.getGlobalDescribe().get(objName);

		if(obj != null) {

			Map<String, Schema.SObjectField> fieldMap = obj.getDescribe().fields.getMap();
			SObjectField field = fieldMap.get(fieldName);

			if(field != null) {
				options = new List<SelectOption>();

				for (Schema.PicklistEntry ple : field.getDescribe().getPicklistValues()) {
					options.add(new SelectOption(ple.getLabel(), ple.getValue()));
				}

			}

		}

		return options;
	}

	/**
	 * Wrapper for picklist values.
	 */
	public class PicklistItem {
		@AuraEnabled public String value {get;set;}
		@AuraEnabled public String label {get;set;}

		PicklistItem(SelectOption option) {
			value = option.getValue();
			label = option.getLabel();
		}
	}

}