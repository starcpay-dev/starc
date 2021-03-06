<?php
/*+***********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 *************************************************************************************/
/**
 * Vtiger Widget Model Class
 */
class Vtiger_Widget_Model extends Vtiger_Base_Model {

	public function getWidth() {
		$largerSizedWidgets = array('GroupedBySalesPerson', 'PipelinedAmountPerSalesPerson', 'GroupedBySalesStage');
		$title = $this->getName();
		if(in_array($title, $largerSizedWidgets)) {
			$this->set('width', '6');
		}
		
		$width = $this->get('width');
		if(empty($width)) {
			$this->set('width', '4');
		}
		return $this->get('width');
	}

	public function getHeight() {
		//Special case for History widget
		$title = $this->getTitle();
		if($title == 'History') {
			$this->set('height', '2');
		}
		$height = $this->get('height');
		if(empty($height)) {
			$this->set('height', '1');
		}
		return $this->get('height');
	}

	/**
	 * Function to get the url of the widget
	 * @return <String>
	 */
	public function getUrl() {
		return decode_html($this->get('linkurl')).'&linkid='.$this->get('linkid');
	}

	/**
	 *  Function to get the Title of the widget
	 */
	public function getTitle() {
		$title = $this->get('title');
		if(empty($title)) {
			$title = $this->get('linklabel');
		}
		return $title;
	}

	public function getName() {
		$widgetName = $this->get('name');
		if(empty($widgetName)){
			//since the html entitites will be encoded
			//TODO : See if you need to push decode_html to base model
			$linkUrl = decode_html($this->getUrl());
			preg_match('/name=[a-zA-Z]+/', $linkUrl, $matches);
			$matches = explode('=', $matches[0]);
			$widgetName = $matches[1];
			$this->set('name', $widgetName);
		}
		return $widgetName;
	}
	/**
	 * Function to get the instance of Vtiger Widget Model from the given array of key-value mapping
	 * @param <Array> $valueMap
	 * @return Vtiger_Widget_Model instance
	 */
	public static function getInstanceFromValues($valueMap) {
		$self = new self();
		$self->setData($valueMap);
		return $self;
	}

	public static function getInstance($linkId, $userId) {
		$db = PearDatabase::getInstance();
		$result = $db->pquery('SELECT * FROM vtiger_module_dashboard_widgets
			INNER JOIN vtiger_links ON vtiger_links.linkid = vtiger_module_dashboard_widgets.linkid
			WHERE linktype = ? AND vtiger_links.linkid = ? AND userid = ?', array('DASHBOARDWIDGET', $linkId, $userId));

		$self = new self();
		if($db->num_rows($result)) {
			$row = $db->query_result_rowdata($result, 0);
			$self->setData($row);
		}
		return $self;
	}
	/**
	 * Function to add a widget from the Users Dashboard
	 */
	public function add() {
		$db = PearDatabase::getInstance();
		$result = $db->pquery('SELECT 1 FROM vtiger_module_dashboard_widgets WHERE linkid = ? AND userid = ?',
				array($this->get('linkid'), $this->get('userid')));
		if(!$db->num_rows($result)) {
			$db->pquery('INSERT INTO vtiger_module_dashboard_widgets(linkid, userid, filterid, title, data) VALUES(?,?,?,?,?)',
					array($this->get('linkid'), $this->get('userid'), $this->get('filterid'), $this->get('title'), Zend_Json::encode($this->get('data'))));
		}
	}

	/**
	 * Function to remove the widget from the Users Dashboard
	 */
	public function remove() {
		$db = PearDatabase::getInstance();
		$db->pquery('DELETE FROM vtiger_module_dashboard_widgets WHERE linkid = ? AND userid = ?',
				array($this->get('linkid'), $this->get('userid')));
	}

	/**
	 * Function returns URL that will remove a widget for a User
	 * @return <String>
	 */
	public function getDeleteUrl() {
		return 'index.php?module=Vtiger&action=RemoveWidget&linkid='. $this->get('linkid');
	}

	/**
	 * Function to check the Widget is Default widget or not
	 * @return <boolean> true/false
	 */
	public function isDefault() {
		$defaultWidgets = $this->getDefaultWidgets();
		$widgetName = $this->getName();

		if (in_array($widgetName, $defaultWidgets)) {
			return true;
		}
		return false;
	}

	/**
	 * Function to get Default widget Names
	 * @return <type>
	 */
	public function getDefaultWidgets() {
		return array('History', 'CalendarActivities');
	}
}