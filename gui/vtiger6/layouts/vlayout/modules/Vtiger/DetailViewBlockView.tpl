{*<!--
/*********************************************************************************
** The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
*
 ********************************************************************************/
-->*}
{strip}
	{foreach key=BLOCK_LABEL_KEY item=FIELD_MODEL_LIST from=$RECORD_STRUCTURE}
	{if $FIELD_MODEL_LIST|@count lte 0}{continue}{/if}
	{assign var=IS_HIDDEN value=$BLOCK_LIST[$BLOCK_LABEL_KEY]->isHidden()}
	<input type=hidden name="timeFormatOptions" data-value='{$DAY_STARTS}' />
	<table class="table table-bordered equalSplit detailview-table">
		<thead>
		<tr>
				<th class="blockHeader" colspan="4">
						<img class="cursorPointer alignMiddle blockToggle {if !($IS_HIDDEN)} hide {/if} "  src="{vimage_path('arrowRight.png')}" data-mode="hide" data-id={$BLOCK_LIST[$BLOCK_LABEL_KEY]->get('id')}>
						<img class="cursorPointer alignMiddle blockToggle {if ($IS_HIDDEN)} hide {/if}"  src="{vimage_path('arrowDown.png')}" data-mode="show" data-id={$BLOCK_LIST[$BLOCK_LABEL_KEY]->get('id')}>
						&nbsp;&nbsp;{vtranslate({$BLOCK_LABEL_KEY},{$MODULE_NAME})}
				</th>
		</tr>
		</thead>
		 <tbody {if $IS_HIDDEN} class="hide" {/if}>
		{assign var=COUNTER value=0}
		<tr>
		{foreach item=FIELD_MODEL key=FIELD_NAME from=$FIELD_MODEL_LIST}
			{if !$FIELD_MODEL->isViewableInDetailView()}
				 {continue}
			 {/if}
			 {if $FIELD_MODEL->get('uitype') eq "83"}
				{foreach item=tax key=count from=$TAXCLASS_DETAILS}
				{if $tax.check_value eq 1}
					{if $COUNTER eq 2}
						</tr><tr>
						{assign var="COUNTER" value=1}
					{else}
						{assign var="COUNTER" value=$COUNTER+1}
					{/if}
					<td class="fieldLabel">
					<label class='muted pull-right marginRight10px'>{vtranslate($tax.taxlabel, $MODULE)}(%)</label>
					</td>
					 <td class="fieldValue">
						 <span class="value">
							 {$tax.percentage}
						 </span>
					 </td>
				{/if}
				{/foreach}
			{else if $FIELD_MODEL->get('uitype') eq "69" || $FIELD_MODEL->get('uitype') eq "105"}
				{if $COUNTER neq 0}
					{if $COUNTER eq 2}
						</tr><tr>
						{assign var=COUNTER value=0}
					{else}
						<td></td><td></td></tr><tr>
						{assign var=COUNTER value=0}
					{/if}
				{/if}
				<td class="fieldLabel" colspan="2"><label class="muted pull-right marginRight10px">{vtranslate({$FIELD_MODEL->get('label')},{$MODULE_NAME})}</label></td>
				<td class="fieldValue" colspan="2">
					{foreach key=ITER item=IMAGE_INFO from=$IMAGE_DETAILS}
						<div class="imageContainer">
							{if !empty($IMAGE_INFO.path) && !empty({$IMAGE_INFO.orgname})}
								<img src="../{$IMAGE_INFO.path}_{$IMAGE_INFO.orgname}">&nbsp;&nbsp;
							{/if}
						</div>
					{/foreach}
				</td>
				</tr><tr>
			{else}
				 {if $COUNTER eq 2}
					 </tr><tr>
					{assign var=COUNTER value=1}
				{else}
					{assign var=COUNTER value=$COUNTER+1}
				 {/if}
				 <td class="fieldLabel" id="{$MODULE}_detailView_fieldLabel_{$FIELD_MODEL->getName()}"><label class="muted pull-right marginRight10px">{vtranslate({$FIELD_MODEL->get('label')},{$MODULE_NAME})}</label></td>
				 <td class="fieldValue" id="{$MODULE}_detailView_fieldValue_{$FIELD_MODEL->getName()}">
					 <span class="value">
                        {include file=vtemplate_path($FIELD_MODEL->getUITypeModel()->getDetailViewTemplateName(),$MODULE_NAME) FIELD_MODEL=$FIELD_MODEL USER_MODEL=$USER_MODEL MODULE=$MODULE_NAME RECORD=$RECORD}
					 </span>
					 {if $FIELD_MODEL->isEditable() eq 'true' && ($FIELD_MODEL->getFieldDataType()!=Vtiger_Field_Model::REFERENCE_TYPE) && $IS_AJAX_ENABLED && $FIELD_MODEL->isAjaxEditable() eq 'true'}
						 <span class="hide edit">
							 {include file=vtemplate_path($FIELD_MODEL->getUITypeModel()->getTemplateName(),$MODULE_NAME) FIELD_MODEL=$FIELD_MODEL USER_MODEL=$USER_MODEL MODULE=$MODULE_NAME}
                             {if $FIELD_MODEL->getFieldDataType() eq 'multipicklist'}
                                <input type="hidden" class="fieldname" value='{$FIELD_MODEL->get('name')}[]' data-prev-value='{$FIELD_MODEL->getDisplayValue($FIELD_MODEL->get('fieldvalue'))}' />
                             {else}
                                 <input type="hidden" class="fieldname" value='{$FIELD_MODEL->get('name')}' data-prev-value='{$FIELD_MODEL->getDisplayValue($FIELD_MODEL->get('fieldvalue'))}' />
                             {/if}
						 </span>
					 {/if}
				 </td>
			 {/if}

		{if $FIELD_MODEL_LIST|@count eq 1 and $FIELD_MODEL->get('uitype') neq "19" and $FIELD_MODEL->get('uitype') neq "20" and $FIELD_MODEL->get('uitype') neq "30" and $FIELD_MODEL->get('name') neq "recurringtype" and $FIELD_MODEL->get('uitype') neq "69" and $FIELD_MODEL->get('uitype') neq "105"}<td></td><td></td>{/if}
		{/foreach}
		</tr>
		</tbody>
	</table>
	{/foreach}
{/strip}