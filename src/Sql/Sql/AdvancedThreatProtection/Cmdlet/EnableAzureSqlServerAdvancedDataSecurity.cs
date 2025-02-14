﻿// ----------------------------------------------------------------------------------
//
// Copyright Microsoft Corporation
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ----------------------------------------------------------------------------------

using Microsoft.Azure.Commands.Sql.AdvancedThreatProtection.Model;
using System.Management.Automation;
using Microsoft.Azure.Commands.Sql.Server.Adapter;
using Microsoft.Azure.Commands.Sql.Server.Model;
using Microsoft.Azure.Commands.Sql.VulnerabilityAssessment.Model;
using Microsoft.Azure.Commands.Sql.VulnerabilityAssessment.Services;

namespace Microsoft.Azure.Commands.Sql.AdvancedThreatProtection.Cmdlet
{
    /// <summary>
    /// Enables the Advanced Threat Protection of a specific server.
    /// </summary>
    [Cmdlet("Enable", ResourceManager.Common.AzureRMConstants.AzureRMPrefix + "SqlServerAdvancedDataSecurity", SupportsShouldProcess = true), OutputType(typeof(ServerAdvancedDataSecurityPolicyModel))]
    [Alias("Enable-AzSqlServerAdvancedThreatProtection")]
    public class EnableAzureSqlServerAdvancedDataSecurity : SqlServerAdvancedDataSecurityCmdletBase
    {
        /// <summary>
        /// Gets or sets the flag indicating that the user doesn't want to auto enable VA (will not create a storage account)
        /// </summary>
        [Parameter(Mandatory = false,
            HelpMessage = "Do not auto enable Vulnerability Assessment (This will not create a storage account)")]
        [ValidateNotNullOrEmpty]
        public SwitchParameter DoNotConfigureVulnerabilityAssessment { get; set; }

        /// <summary>
        /// Gets or sets whether or not to run this cmdlet in the background as a job
        /// </summary>
        [Parameter(Mandatory = false, HelpMessage = "Run cmdlet in the background")]
        public SwitchParameter AsJob { get; set; }

        /// <summary>
        /// A custom name for Advanced Data Security deployment
        /// </summary>
        [Parameter(Mandatory = false,
            HelpMessage = "Supply a custom name for Advanced Data Security deployment")]
        [ValidateNotNullOrEmpty]
        public string DeploymentName { get; set; }

        /// <summary>
        /// This method is responsible to call the right API in the communication layer that will eventually send the information in the 
        /// object to the REST endpoint
        /// </summary>
        /// <param name="model">The model object with the data to be sent to the REST endpoints</param>
        protected override ServerAdvancedDataSecurityPolicyModel PersistChanges(ServerAdvancedDataSecurityPolicyModel model)
        {
            model.IsEnabled = true;

            if (DoNotConfigureVulnerabilityAssessment)
            {
                ModelAdapter.SetServerAdvancedDataSecurity(model);
            }
            else
            {
                // Deploy arm template to enable VA - only if VA at server level is not defined
                var vaAdapter = new SqlVulnerabilityAssessmentAdapter(DefaultContext);
                var vaModel = vaAdapter.GetVulnerabilityAssessmentSettings(ResourceGroupName, ServerName, "", ApplyToType.Server);

                if (string.IsNullOrEmpty(vaModel.StorageAccountName))
                {
                    var serverAdapter = new AzureSqlServerAdapter(DefaultContext);
                    AzureSqlServerModel serverModel = serverAdapter.GetServer(ResourceGroupName, ServerName);
                    ModelAdapter.EnableServerAdsWithVa(ResourceGroupName, ServerName, serverModel.Location, DeploymentName);
                }
                else
                {
                    ModelAdapter.SetServerAdvancedDataSecurity(model);
                }
            }

            return model;
        }
    }
}
