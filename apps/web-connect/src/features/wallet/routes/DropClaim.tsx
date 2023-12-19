import {useAccount, useNetwork} from "wagmi";
import {XaiBanner} from "@/features/checkout/XaiBanner";
import {XaiCheckbox} from "@sentry/ui";
import {KYCTooltip} from "@/features/checkout/KYCTooltip";
import {useEffect, useState} from "react";
import {useListClaimableAmount} from "@/features/checkout/hooks/useListClaimableAmount";
import {BiLoaderAlt} from "react-icons/bi";

export function DropClaim() {
	const {address} = useAccount();
	const {chain} = useNetwork();

	const [eligible, setEligible] = useState<boolean>(false);
	const [keys,] = useState(15);

	const [checkboxOne, setCheckboxOne] = useState<boolean>(false);
	const [checkboxTwo, setCheckboxTwo] = useState<boolean>(false);
	const [checkboxThree, setCheckboxThree] = useState<boolean>(false);
	const ready = checkboxOne && checkboxTwo && checkboxThree;

	const {data: claimableAmountData, isLoading: isClaimableAmountLoading} = useListClaimableAmount(address);

	if (!isClaimableAmountLoading) {
		console.log("claimableAmount: ", claimableAmountData);
	}

	useEffect(() => {
		if (keys !== 0) {
			setEligible(true)
		} else if (keys <= 0) {
			setEligible(false)
		}
	}, [keys]);

	return (
		<div>
			<div className="h-full min-h-[90vh] flex flex-col justify-center items-center">
				<XaiBanner/>
				<div
					className="flex flex-col justify-center items-center w-[744px] border border-gray-200 bg-white m-4 p-12">
					<div
						className="flex flex-col justify-center items-center gap-2 w-full overflow-hidden">
						<p className="text-3xl font-semibold">
							Redeem Sentry Keys
						</p>

						{isClaimableAmountLoading ? (
							<div className="w-full h-[390px] flex flex-col justify-center items-center gap-2">
								<BiLoaderAlt className="animate-spin" color={"#A3A3A3"} size={32}/>
								<p>Loading...</p>
							</div>
						) : (
							<>


								{!address && (
									<p className="text-lg text-[#525252] max-w-[590px] text-center mt-2">
										Connect your wallet to check your eligibility.
									</p>
								)}

								{address ? (
									<>
										{eligible ? (
											<>
												<p className="text-lg text-[#525252] max-w-[590px] text-center mt-2">
													This wallet ({address}) can claim <span
													className="font-semibold">{keys}</span> {keys === 1 ? "key" : "keys"}.
												</p>
												<div className="flex flex-col justify-center gap-8 p-6 mt-8">
													<div className="flex flex-col justify-center gap-2">
														<XaiCheckbox
															onClick={() => setCheckboxOne(!checkboxOne)}
															condition={checkboxOne}
														>
															I agree with the
															<a
																className="cursor-pointer text-[#F30919]"
																onClick={() => window.open("https://xai.games/sentrynodeagreement/")}>
																Sentry Node Agreement
															</a>
														</XaiCheckbox>


														<XaiCheckbox
															onClick={() => setCheckboxTwo(!checkboxTwo)}
															condition={checkboxTwo}
														>
															I understand Sentry Node Keys are not transferable
														</XaiCheckbox>

														<XaiCheckbox
															onClick={() => setCheckboxThree(!checkboxThree)}
															condition={checkboxThree}
														>
															I understand that I cannot claim rewards until I pass KYC
															<KYCTooltip
																width={850}
															>
																<p className="text-[#F30919]">(SEE BLOCKED
																	COUNTRIES)</p>
															</KYCTooltip>
														</XaiCheckbox>
													</div>

													<div>
														<button
															// onClick={() => write}
															className={`w-[576px] h-16 ${checkboxOne && checkboxTwo && checkboxThree && chain?.id === 42_161 ? "bg-[#F30919]" : "bg-gray-400 cursor-default"} text-sm text-white p-2 uppercase font-semibold`}
															disabled={!ready || chain?.id !== 42_161}
														>
															{chain?.id === 42_161 ? "Claim" : "Please Switch to Arbitrum One"}
														</button>
													</div>
												</div>
											</>
										) : (
											<>
												<p className="text-lg text-[#525252] max-w-[590px] text-center mt-2">
													This wallet ({address}) is ineligible to claim any Xai Sentry Keys.
												</p>
												<p className="text-lg text-[#525252] max-w-[590px] text-center mt-2">
													You can connect a different wallet to determine if it is eligible.
												</p>
											</>
										)}
									</>
								) : (
									<div className="m-8">
										<w3m-button/>
									</div>
								)}
							</>
						)}
					</div>
				</div>
			</div>
		</div>
	)
}
