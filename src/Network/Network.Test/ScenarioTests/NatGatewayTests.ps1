﻿# Copyright (c) Microsoft and contributors.  All rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# 
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# 
# Warning: This code was generated by a tool.
# 
# Changes to this file may cause incorrect behavior and will be lost if the
# code is regenerated.
# 
# For documentation on code generator please visit
#   https://aka.ms/nrp-code-generation
# Please contact wanrpdev@microsoft.com if you need to make changes to this file.
# </auto-generated>

function Check-CmdletReturnType
{
    param($cmdletName, $cmdletReturn)

    $cmdletData = Get-Command $cmdletName;
    Assert-NotNull $cmdletData;
    [array]$cmdletReturnTypes = $cmdletData.OutputType.Name | Foreach-Object { return ($_ -replace "Microsoft.Azure.Commands.Network.Models.","") };
    [array]$cmdletReturnTypes = $cmdletReturnTypes | Foreach-Object { return ($_ -replace "System.","") };
    $realReturnType = $cmdletReturn.GetType().Name -replace "Microsoft.Azure.Commands.Network.Models.","";
    return $cmdletReturnTypes -contains $realReturnType;
}

<#
.SYNOPSIS
Test creating new NatGateway using minimal set of parameters
#>
function Test-NatGatewayCRUDMinimalParameters
{
    # Setup
    $rgname = Get-ResourceGroupName;
    $rglocation = Get-ProviderLocation ResourceManagement;
    $rname = Get-ResourceName;
    $location = Get-ProviderLocation "Microsoft.Network/networkWatchers" "East US 2";

    try
    {
        $resourceGroup = New-AzResourceGroup -Name $rgname -Location $rglocation;

        # Create NatGateway
        $vNatGateway = New-AzNatGateway -ResourceGroupName $rgname -Name $rname -Location $location -Sku Standard;
        Assert-NotNull $vNatGateway;
        Assert-True { Check-CmdletReturnType "New-AzNatGateway" $vNatGateway };
        Assert-AreEqual $rname $vNatGateway.Name;

        # Get NatGateway
        $vNatGateway = Get-AzNatGateway -ResourceGroupName $rgname -Name $rname;
        Assert-NotNull $vNatGateway;
        Assert-True { Check-CmdletReturnType "Get-AzNatGateway" $vNatGateway };
        Assert-AreEqual $rname $vNatGateway.Name;

        # Get all NatGateways in resource group
        $listNatGateway = Get-AzNatGateway -ResourceGroupName $rgname;
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Get all NatGateways in subscription
        $listNatGateway = Get-AzNatGateway;
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Get all NatGateways in subscription wildcard for resource group
        $listNatGateway = Get-AzNatGateway -ResourceGroupName "*";
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Get all NatGateways in subscription wildcard for both resource group and name
        $listNatGateway = Get-AzNatGateway -ResourceGroupName "*" -Name "*";
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Remove NatGateway
        $job = Remove-AzNatGateway -ResourceGroupName $rgname -Name $rname -PassThru -Force -AsJob;
        $job | Wait-Job;
        $removeNatGateway = $job | Receive-Job;
        Assert-AreEqual $true $removeNatGateway;

        # Get NatGateway should fail
        Assert-ThrowsContains { Get-AzNatGateway -ResourceGroupName $rgname -Name $rname } "not found";
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname;
    }
}

<#
.SYNOPSIS
Test creating new NatGateway using minimal set of parameters
#>
function Test-NatGatewayWithSubnet
{
    # Setup
    $rgname = Get-ResourceGroupName;
    $rglocation = Get-ProviderLocation ResourceManagement;
    $rname = Get-ResourceName;
	$vnetName = Get-ResourceName;
    $subnetName = Get-ResourceName;
    $location = Get-ProviderLocation "Microsoft.Network/networkWatchers" "East US 2";
	$sku = "Standard";

    try
    {
        $resourceGroup = New-AzResourceGroup -Name $rgname -Location $rglocation;

        # Create NatGateway
        $vNatGateway = New-AzNatGateway -ResourceGroupName $rgname -Name $rname -Location $location -sku $sku;
        Assert-NotNull $vNatGateway;
        Assert-True { Check-CmdletReturnType "New-AzNatGateway" $vNatGateway };
        Assert-AreEqual $rname $vNatGateway.Name;

        # Get NatGateway
        $vNatGateway = Get-AzNatGateway -ResourceGroupName $rgname -Name $rname;
        Assert-NotNull $vNatGateway;
        Assert-True { Check-CmdletReturnType "Get-AzNatGateway" $vNatGateway };
        Assert-AreEqual $rname $vNatGateway.Name;

        # Get all NatGateways in resource group
        $listNatGateway = Get-AzNatGateway -ResourceGroupName $rgname;
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Get all NatGateways in subscription
        $listNatGateway = Get-AzNatGateway;
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Get all NatGateways in subscription wildcard for resource group
        $listNatGateway = Get-AzNatGateway -ResourceGroupName "*";
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Get all NatGateways in subscription wildcard for both resource group and name
        $listNatGateway = Get-AzNatGateway -ResourceGroupName "*" -Name "*";
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Create Subnet
        $subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.1.0/24 -InputObject $vNatGateway
        New-AzvirtualNetwork -Name $vnetName -ResourceGroupName $rgname -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $subnet
        $vnet = Get-AzvirtualNetwork -Name $vnetName -ResourceGroupName $rgname

        # Get Subnet
        $subnet2 = Get-AzvirtualNetwork -Name $vnetName -ResourceGroupName $rgname | Get-AzVirtualNetworkSubnetConfig -Name $subnetName;

        Assert-AreEqual $vNatGateway.Id @($subnet2.NatGateway.Id)

        # Remove Subnet
        Remove-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet
        Set-AzVirtualNetwork -VirtualNetwork $vnet

        # Remove NatGateway
        $job = Remove-AzNatGateway -ResourceGroupName $rgname -Name $rname -PassThru -Force -AsJob;
        $job | Wait-Job;
        $removeNatGateway = $job | Receive-Job;
        Assert-AreEqual $true $removeNatGateway;

        # Get NatGateway should fail
        Assert-ThrowsContains { Get-AzNatGateway -ResourceGroupName $rgname -Name $rname } "not found";
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname;
    }
}

<#
.SYNOPSIS
Test creating new NatGateway
#>
function Test-NatGatewayCRUDAllParameters
{
    # Setup
    $rgname = Get-ResourceGroupName;
    $rglocation = Get-ProviderLocation ResourceManagement;
    $rname = Get-ResourceName;
    $location = Get-ProviderLocation "Microsoft.Network/networkWatchers" "East US 2";
    # Resource's parameters
    $IdleTimeoutInMinutes = 5;
    $Tag = @{tag1='test'};
    # Resource's parameters for Set test
    $IdleTimeoutInMinutesSet = 10;
    $TagSet = @{tag2='testSet'};

    try
    {
        $resourceGroup = New-AzResourceGroup -Name $rgname -Location $rglocation;

        # Create NatGateway
        $vNatGateway = New-AzNatGateway -ResourceGroupName $rgname -Name $rname -Location $location -IdleTimeoutInMinutes $IdleTimeoutInMinutes -Tag $Tag -Sku Standard;
        Assert-NotNull $vNatGateway;
        Assert-True { Check-CmdletReturnType "New-AzNatGateway" $vNatGateway };
        Assert-AreEqual $rname $vNatGateway.Name;
        Assert-AreEqual $IdleTimeoutInMinutes $vNatGateway.IdleTimeoutInMinutes;
        Assert-AreEqualObjectProperties $Tag $vNatGateway.Tag;

        # Get NatGateway
        $vNatGateway = Get-AzNatGateway -ResourceGroupName $rgname -Name $rname;
        Assert-NotNull $vNatGateway;
        Assert-True { Check-CmdletReturnType "Get-AzNatGateway" $vNatGateway };
        Assert-AreEqual $rname $vNatGateway.Name;
        Assert-AreEqual $IdleTimeoutInMinutes $vNatGateway.IdleTimeoutInMinutes;
        Assert-AreEqualObjectProperties $Tag $vNatGateway.Tag;

        # Get all NatGateways in resource group
        $listNatGateway = Get-AzNatGateway -ResourceGroupName $rgname;
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Get all NatGateways in subscription
        $listNatGateway = Get-AzNatGateway;
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Get all NatGateways in subscription wildcard for resource group
        $listNatGateway = Get-AzNatGateway -ResourceGroupName "*";
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Get all NatGateways in subscription wildcard for both resource group and name
        $listNatGateway = Get-AzNatGateway -ResourceGroupName "*" -Name "*";
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Set NatGateway
        $vNatGateway.Tag = $TagSet;
        $vNatGateway = Set-AzNatGateway -InputObject $vNatGateway -IdleTimeoutInMinutes $IdleTimeoutInMinutesSet;
        Assert-NotNull $vNatGateway;
        Assert-True { Check-CmdletReturnType "Set-AzNatGateway" $vNatGateway };
        Assert-AreEqual $rname $vNatGateway.Name;
        Assert-AreEqual $IdleTimeoutInMinutesSet $vNatGateway.IdleTimeoutInMinutes;
        Assert-AreEqualObjectProperties $TagSet $vNatGateway.Tag;

        # Get NatGateway
        $vNatGateway = Get-AzNatGateway -ResourceGroupName $rgname -Name $rname;
        Assert-NotNull $vNatGateway;
        Assert-True { Check-CmdletReturnType "Get-AzNatGateway" $vNatGateway };
        Assert-AreEqual $rname $vNatGateway.Name;
        Assert-AreEqual $IdleTimeoutInMinutesSet $vNatGateway.IdleTimeoutInMinutes;
        Assert-AreEqualObjectProperties $TagSet $vNatGateway.Tag;

        # Get all NatGateways in resource group
        $listNatGateway = Get-AzNatGateway -ResourceGroupName $rgname;
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Get all NatGateways in subscription
        $listNatGateway = Get-AzNatGateway;
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Get all NatGateways in subscription wildcard for resource group
        $listNatGateway = Get-AzNatGateway -ResourceGroupName "*";
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Get all NatGateways in subscription wildcard for both resource group and name
        $listNatGateway = Get-AzNatGateway -ResourceGroupName "*" -Name "*";
        Assert-NotNull ($listNatGateway | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $rname });

        # Remove NatGateway
        $job = Remove-AzNatGateway -ResourceGroupName $rgname -Name $rname -PassThru -Force -AsJob;
        $job | Wait-Job;
        $removeNatGateway = $job | Receive-Job;
        Assert-AreEqual $true $removeNatGateway;

        # Get NatGateway should fail
        Assert-ThrowsContains { Get-AzNatGateway -ResourceGroupName $rgname -Name $rname } "not found";

        # Set NatGateway should fail
        Assert-ThrowsContains { Set-AzNatGateway -InputObject $vNatGateway } "not found";
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname;
    }
}