<script>
	import { onMount } from 'svelte';
	import { api } from '$lib/api';
	import QRCode from 'qrcode';
	import PendingIcon from '$icons/pending.svelte';
	import { address, amount, unit } from '$lib/stores';
	import { copy as copyToClipboard } from '$lib/utils';
	import Options from '$components/options.svelte';

	let copied;
	let copy = () => {
		copyToClipboard($address);
		copied = true;
		setTimeout(() => (copied = false), 3000);
	};

	let qrData;
	let qrCode;

	let ticketNumber;

	$: tier = ticketNumber < 100 ? 1 : ticketNumber < 1000 ? 2 : 3;
	$: prefix = {
		BTC: 'bitcoin',
		LTC: 'litecoin',
		LBTC: 'liquidnetwork',
		LNBTC: 'lightning'
	}[$unit];

	const paymentLabel = 'Silhouettes';
	const paymentMessage = 'Movie ticket';

	onMount(async () => {
		ticketNumber = await api.url('/ticket').get().json();
	});

	$: url =
		$unit === 'LNBTC'
			? `${prefix}:${$address}`
			: `${prefix}:${$address}?amount=${$amount}&label=Silhouettes&message=Movie%20ticket`;

	$: updateQr(url);
	let updateQr = (url) => {
		QRCode.toString(
			url,
			{
				errorCorrectionLevel: 'H',
				type: 'svg',
				width: '250',
				height: '250',
				color: {
					dark: '#1f4e6c',
					light: '#FFFFFF'
				}
			},
			function (err, string) {
				if (err) {
					throw err;
				}
				qrCode = string;
			}
		);
	};

	let showInfo;
</script>

<div class="container column">
	{#if $amount}
		<div class="container mb">
			Purchasing ticket #{ticketNumber} - Tier {tier}
		</div>

		<div class="container mb">
			<button on:click={() => (showInfo = !showInfo)}>What Are The Tiers?</button>
		</div>

		{#if showInfo}
			<img
				src="/static/tiers.png"
				alt="Silhouette Tiers"
				style="max-width: 30em; width: 100%; margin: 0 auto 1em auto;"
			/>
			<div class="container mb">
				<button on:click={() => (showInfo = !showInfo)}>Got it!</button>
			</div>
		{/if}

		<div class="page-block">
      <div class="container">Please send <b style="margin: 0 0.3em">{$amount} {$unit}</b> ($20 USD) to:</div>

			<div id="payment-qr-code" class="container column">
				<div class="container">
					<a href={url} target="_blank">
						{@html qrCode}
					</a>
				</div>
				<div class="container column mb">
					<a href={url} target="_blank">
						<p
							id="payment-url"
							style="word-wrap: break-word; max-width: 600px; padding: 0 15px; margin: 0 auto; line-height: 1.5em;"
						>
							{$address}
						</p>
					</a>
				</div>
				<div class="container mb">
					<button on:click={copy}>
						{#if copied}
							Copied!
						{:else}
							Copy
						{/if}
					</button>
				</div>
			</div>
		</div>
	{/if}
	<Options />
</div>

<style>
	#payment-qr-code {
		width: 100%;
	}
	#payment-qr-code p {
		text-align: center;
		margin: 0;
	}
</style>
